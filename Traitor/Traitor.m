//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "Traitor+Internal.h"

#import <objc/runtime.h>

// Returns whether class inherits from superclass.
BOOL classInheritsFromClass(Class superclass, Class class)
{
    if (class == superclass) { return YES; }
    class = class_getSuperclass(class);
    if (class == Nil) { return NO; }
    
    return classInheritsFromClass(superclass, class);
}

// Returns a *mumble*enumerable*mumble* of all clases that have the given superclass in their ancestry.
id<NSFastEnumeration> allClassesInheritingFromClass(Class superclass)
{
    NSMutableSet *result = [NSMutableSet new];
    
    unsigned int classCount;
    Class *classes = objc_copyClassList(&classCount);
    
    for (NSUInteger i = 0; i < classCount; i++) {
        Class class = classes[i];
        
        if (classInheritsFromClass(superclass, class) && class != superclass) {
            [result addObject:class];
        }
    }
    
    if (classes) {
        free(classes);
        classes = NULL;
    }
    
    return result;
}
