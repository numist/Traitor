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


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"


@interface NNSetTrait : TRTrait <NNSetTrait>
@end


@implementation NNSetTrait

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

- (instancetype)setByUnionWithSet:(id<NNSetTrait>)otherSet;
{
    NSMutableSet *result = [NSMutableSet setWithArray:[self allObjects]];
    
    for (id object in otherSet) {
        [result addObject:object];
    }
    
    return [[[self class] alloc] initWithArray:[result allObjects]];
}

- (instancetype)setByRemovingFromSet:(id<NNSetTrait>)otherSet;
{
    NSMutableSet *result = [NSMutableSet setWithArray:[self allObjects]];
    
    for (id object in otherSet) {
        if ([result containsObject:object]) {
            [result removeObject:object];
        }
    }
    
    return [[[self class] alloc] initWithArray:[result allObjects]];
}

- (instancetype)setByIntersectionWithSet:(id<NNSetTrait>)otherSet;
{
    NSMutableSet *result = [NSMutableSet setWithArray:[self allObjects]];
    NSMutableSet *objectsToRemove = [NSMutableSet new];
    
    for (id object in result) {
        if (![otherSet containsObject:object]) {
            [objectsToRemove addObject:object];
        }
    }
    [result minusSet:objectsToRemove];
    
    return [[[self class] alloc] initWithArray:[result allObjects]];
}

@end
