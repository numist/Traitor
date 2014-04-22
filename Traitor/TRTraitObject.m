//
//  TRTraitObject.m
//  Traitor
//
//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "TRTraitObject.h"

#import <objc/runtime.h>

#import "TRTrait.h"


@implementation TRTraitObject

// Returns whether class inherits from superclass.
static BOOL classInheritsFromClass(Class superclass, Class class)
{
    if (class == superclass) { return YES; }
    class = class_getSuperclass(class);
    if (class == Nil) { return NO; }
    
    return classInheritsFromClass(superclass, class);
}

// Returns the class object for the protocol parameter, if it describes an aspect (if the class inherits from TRTrait)
static Class aspectImplementationForProtocol(Protocol *protocol)
{
    NSString *className = [NSString stringWithFormat:@"%s", protocol_getName(protocol)];
    Class matchClass = NSClassFromString(className);
    
    if (!matchClass) { return Nil; }
    if (!classInheritsFromClass([TRTrait class], matchClass)) { return Nil; }
    
    return matchClass;
}

// Returns all of the aspect class objects, including inherited aspects, for the class.
static NSSet *aspectImplementationsForClass(Class class)
{
    unsigned int protocolCount;
    Protocol * __unsafe_unretained *protocols;
    
    if (classInheritsFromClass([TRTrait class], class)) {
        Protocol *aspectProtocol = objc_getProtocol(class_getName(class));
        protocols = protocol_copyProtocolList(aspectProtocol, &protocolCount);
    } else {
        protocols = class_copyProtocolList(class, &protocolCount);
    }
    
    
    NSMutableSet *aspectImplementations = [NSMutableSet new];
    
    // Enumerate all protocols this class conforms to, select matching class definition that inherits from TRTrait
    for (NSUInteger i = 0; i < protocolCount; i++) {
        Protocol *protocol = protocols[i];
        
        // Avoid infinite recursion getting the self aspect.
        if (!strcmp(protocol_getName(protocol), class_getName(class))) { continue; }
        
        Class aspectImplementation = aspectImplementationForProtocol(protocols[i]);
        if (aspectImplementation) {
            [aspectImplementations addObject:aspectImplementation];
            // Recurse for inherited aspects.
            [aspectImplementations as_addObjectsFromSet:aspectImplementationsForClass(aspectImplementation)];
        }
    }
    
    if (protocols) {
        free(protocols);
        protocols = NULL;
    }
    
    return aspectImplementations;
}

// Returns all selector names for methods provided by the given aspect implementation.
static NSSet *selectorNamesForTraitImplementation(Class class)
{
    Protocol *protocol = NSProtocolFromString(NSStringFromClass(class));
    NSMutableSet *result = [NSMutableSet new];
    
    // Poor attempt at named parameters in C :(
    BOOL isRequiredMethod = NO;
    BOOL isInstanceMethod = YES;
    unsigned int descriptionCount;
    struct objc_method_description *descriptions = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &descriptionCount);

    for (NSUInteger i = 0; i < descriptionCount; i++) {
        [result addObject:NSStringFromSelector(descriptions[i].name)];
    }
    
    if (descriptions) {
        free(descriptions);
        descriptions = NULL;
    }
    
    return result;
}

// Returns whether the given class (and not its superclasses!) implements the given selector.
static BOOL classImplementsMethod(Class class, SEL selector)
{
    BOOL result = NO;
    
    unsigned int methodCount;
    Method *methods = class_copyMethodList(class, &methodCount);
    
    for (NSUInteger i = 0; i < methodCount; i++) {
        if (method_getName(methods[i]) == selector) {
            result = YES;
            break;
        }
    }
    
    if (methods) {
        free(methods);
        methods = NULL;
    }
    
    return result;
}

// Installs the method on sourceClass that matches the selector sourceSelector into destinationClass with the selector destinationSelector.
static void copyMethodFromClass(Class destinationClass, SEL destinationSelector, Class sourceClass, SEL sourceSelector)
{
    if (classImplementsMethod(destinationClass, destinationSelector)) { return; }
    
    NSLog(@"Installing method %@ on class %@", NSStringFromSelector(destinationSelector), NSStringFromClass(destinationClass));
    
    Method sourceMethod = class_getInstanceMethod(sourceClass, sourceSelector);
    
    BOOL success = class_addMethod(destinationClass, destinationSelector, method_getImplementation(sourceMethod), method_getTypeEncoding(sourceMethod));
    NSCAssert(success, @"Whyyyy");
}

// Returns a *mumble*enumerable*mumble* of all clases that have the given superclass in their ancestry.
static id<NSFastEnumeration> allClassesInheritingFromClass(Class superclass)
{
    NSMutableSet *result = [NSMutableSet new];
    
    unsigned int classCount;
    Class *classes = objc_copyClassList(&classCount);
    
    for (NSUInteger i = 0; i < classCount; i++) {
        Class class = classes[i];
        
        if (classInheritsFromClass(superclass, class)) {
            [result addObject:class];
        }
    }
    
    if (classes) {
        free(classes);
        classes = NULL;
    }
    
    return result;
}

// Trait implementation stuff that should really be done at compile-time.
static void installTraitMethodsForClass(Class class)
{
    // Find all the aspects (Protocols that have matching implementations that inherit from TRTrait) that this (sub)class is tagged with.
    id<NSFastEnumeration> aspects = aspectImplementationsForClass(class);
    
    // All selector names implemented by every inherited aspect.
    NSMutableSet *allSelectorNames = [NSMutableSet new];
    
    // All selector names duplicated by multiple inherited aspects.
    NSMutableSet *duplicatedSelectorNames = [NSMutableSet new];
    
    // Selector name -> aspect class mapping for all non-duplicated selectors.
    NSMutableDictionary *selectorNameMap = [NSMutableDictionary new];
    
    for (Class aspect in aspects) {
        NSSet *selectorNames = selectorNamesForTraitImplementation(aspect);
        
        [duplicatedSelectorNames as_addObjectsFromSet:[allSelectorNames as_intersectSet:selectorNames]];
        [allSelectorNames unionSet:selectorNames];
        
        for (NSString *selectorName in selectorNames) {
            // Install tagged selector into class.
            NSString *taggedSelectorName = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(aspect), selectorName];
            copyMethodFromClass(class, NSSelectorFromString(taggedSelectorName), aspect, NSSelectorFromString(selectorName));
            
            [selectorNameMap setObject:aspect forKey:selectorName];
        }
    }
    
    // This isn't strictly necessary because installNewMethodFromClass will skip methods that are overridden, and all duplicated aspect methods must be overridden, per the loop below.
    [selectorNameMap removeObjectsForKeys:[duplicatedSelectorNames allObjects]];
    
    // Check that this class implements the duplicates or explode
    for (NSString *duplicatedSelectorName in duplicatedSelectorNames) {
        if (!classImplementsMethod(class, NSSelectorFromString(duplicatedSelectorName))) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"The method %@ is defined by multiple aspects and must be overridden by class %@", duplicatedSelectorName, NSStringFromClass(class)] userInfo:nil];
        }
    }
    
    // Inset all non-implemented unique aspect selectors with the form: methodName:
    for (NSString *uniqueSelectorName in [selectorNameMap allKeys]) {
        copyMethodFromClass(class, NSSelectorFromString(uniqueSelectorName), selectorNameMap[uniqueSelectorName], NSSelectorFromString(uniqueSelectorName));
    }
}

+ (void)initialize;
{
    if (self != [TRTraitObject class]) { return; }
    
    for (Class subclass in allClassesInheritingFromClass(self)) {
        installTraitMethodsForClass(subclass);
    }
}

@end
