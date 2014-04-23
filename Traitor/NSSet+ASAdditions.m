//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSSet+ASAdditions.h"


@implementation NSSet (ASAdditions)

- (instancetype)as_unionSet:(NSSet *)otherSet;
{
    NSMutableSet *result = [self mutableCopy];
    [result unionSet:otherSet];
    return result;
}

- (instancetype)as_minusSet:(NSSet *)otherSet;
{
    NSMutableSet *result = [self mutableCopy];
    [result minusSet:otherSet];
    return result;
}

- (instancetype)as_intersectSet:(NSSet *)otherSet;
{
    NSMutableSet *result = [self mutableCopy];
    [result intersectSet:otherSet];
    return result;
}

@end


@implementation NSMutableSet (ASAdditions)

+ (instancetype)as_setFromEnumerable:(id<NSFastEnumeration>)enumerable;
{
    NSMutableSet *result = [NSMutableSet new];
    
    for (id object in enumerable) {
        [result addObject:object];
    }
    
    return result;
}

- (void)as_addObjectsFromSet:(NSSet *)otherSet;
{
    [self addObjectsFromArray:[otherSet allObjects]];
}

@end
