//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NNSetTrait.h"

#import <Traitor/Traitor.h>


@interface NNSetTrait : TRTrait <NNSetTrait>
@end


@implementation NNSetTrait

- (NSUInteger)count;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
};

- (id)member:(id)object;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
};

- (NSEnumerator *)objectEnumerator;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
};

- (NSArray *)allObjects;
{
    return [self.objectEnumerator allObjects];
}

- (id)anyObject;
{
    return [self.objectEnumerator nextObject];
}

- (BOOL)containsObject:(id)anObject;
{
    return !![self member:anObject];
}

- (NSString *)description;
{
    return [[NSSet setWithArray:self.allObjects] description];
}

- (BOOL)intersectsSet:(id<NNSetTrait>)otherSet;
{
    for (id object in self) {
        if ([otherSet containsObject:object]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isEqualToSet:(id<NNSetTrait>)otherSet;
{
    if (self.count != otherSet.count) {
        return NO;
    }
    
    return [self isSubsetOfSet:otherSet];
}

- (BOOL)isSubsetOfSet:(id<NNSetTrait>)otherSet;
{
    if (self.count > otherSet.count) {
        return NO;
    }
    
    for (id object in self) {
        if (![otherSet containsObject:object]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
{
    NSArray *allObjects = [[self allObjects] sortedArrayUsingComparator:^(id obj1, id obj2) {
        if (obj1 > obj2) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if (obj1 < obj2) {
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            NSAssert(obj1 != obj2, @"Wait, sets aren't supposed to contain duplicates…");
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    NSUInteger i, count;
    for (i = state->state, count = 0; i < allObjects.count && count < len; count++, i++) {
        buffer[i] = allObjects[i];
    }
    
    state->state = i;
    state->itemsPtr = buffer;
    // Sorry, but I have no intrinsic state variables.
    state->mutationsPtr = (__bridge void *)self;
    
    return count;
}

@end
