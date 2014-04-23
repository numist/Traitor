//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "TRTrait.h"

#import <objc/runtime.h>


@implementation TRTrait

+ (void)initialize;
{
    if (self != [TRTrait class]) { return; }
    
    for (Class subclass in allClassesInheritingFromClass(self)) {
        // Check that class has a matching protocol.
        Protocol *protocol = objc_getProtocol(class_getName(subclass));
        if (!protocol) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Class %@ does not have a corresponding declaration protocol.", NSStringFromClass(subclass)] userInfo:nil];
        }
        
        BOOL isRequiredMethod = NO;
        BOOL isInstanceMethod = YES;
        unsigned int methodCount;
        struct objc_method_description *methods;
        
        // Check that class implements all of the optional protocol methods.
        methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
        
        NSMutableArray *unimplementedMethods = [NSMutableArray new];
        for (unsigned int i = 0; i < methodCount; i++) {
            SEL selector = methods[i].name;
            if (![subclass instancesRespondToSelector:selector]) {
                [unimplementedMethods addObject:NSStringFromSelector(selector)];
            }
        }
        if (unimplementedMethods.count) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Class %@ is missing required methods for functioning as a trait", NSStringFromClass(subclass)] userInfo:@{ @"requiredMethods" : unimplementedMethods }];
        }
        
        if (methods) {
            free(methods);
            methods = NULL;
        }
        
        // Check that class does not implement any of the required protocol methods.
        isRequiredMethod = YES;
        methods = protocol_copyMethodDescriptionList(protocol, isRequiredMethod, isInstanceMethod, &methodCount);
        
        NSMutableArray *implementedMethods = [NSMutableArray new];
        for (unsigned int i = 0; i < methodCount; i++) {
            SEL selector = methods[i].name;
            if ([subclass instancesRespondToSelector:selector]) {
                [implementedMethods addObject:NSStringFromSelector(selector)];
            }
        }
        if (implementedMethods.count) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Class %@ implements methods that are required by the trait inheritor", NSStringFromClass(subclass)] userInfo:@{ @"requiredMethods" : implementedMethods }];
        }
        
        if (methods) {
            free(methods);
            methods = NULL;
        }
    }
}

@end
