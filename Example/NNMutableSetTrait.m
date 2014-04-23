//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NNMutableSetTrait.h"

#import <Traitor/Traitor.h>


@interface NNMutableSetTrait : TRTrait <NNMutableSetTrait>
@end

@implementation NNMutableSetTrait

- (void)addObject:(id)object;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
}

- (void)removeObject:(id)object;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
}

- (void)addObjectsFromArray:(NSArray *)array;
{
    for (id object in array) {
        [self addObject:object];
    }
}

- (void)intersectSet:(NSSet *)otherSet;
{
    for (id object in [[self allObjects] copy]) {
        if (![otherSet containsObject:object]) {
            [self removeObject:object];
        }
    }
}

- (void)minusSet:(NSSet *)otherSet;
{
    for (id object in otherSet) {
        if ([self containsObject:object]) {
            [self removeObject:object];
        }
    }
}

- (void)removeAllObjects;
{
    while (self.count) {
        [self removeObject:[self anyObject]];
    }
}

- (void)unionSet:(NSSet *)otherSet;
{
    for (id object in otherSet) {
        [self addObject:object];
    }
}

- (void)setSet:(NSSet *)otherSet;
{
    [self removeAllObjects];
    [self unionSet:otherSet];
}

@end
