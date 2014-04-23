//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NNMutableArrayTrait.h"

#import <Traitor/Traitor.h>


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"


@interface NNMutableArrayTrait : TRTrait <NNMutableArrayTrait>
@end


@implementation NNMutableArrayTrait

- (void)addObject:(id)anObject;
{
    [self insertObject:anObject atIndex:self.count];
}

- (void)removeLastObject;
{
    [self removeObjectAtIndex:self.count - 1];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
{
    [self removeObjectAtIndex:index];
    [self insertObject:anObject atIndex:index];
}

- (void)addObjectsFromArray:(NSArray *)otherArray;
{
    for (id object in otherArray) {
        [self addObject:object];
    }
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
{
    id obj = self[idx1];
    self[idx1] = self[idx2];
    self[idx2] = obj;
}

- (void)removeAllObjects;
{
    while (self.count) {
        [self removeLastObject];
    }
}

- (void)removeObject:(id)anObject inRange:(NSRange)range;
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        if ([self[i] isEqual:anObject]) {
            [indexSet addIndex:i];
        }
    }
    
    [self removeObjectsAtIndexes:indexSet];
}

- (void)removeObject:(id)anObject;
{
    [self removeObject:anObject inRange:NSMakeRange(0, self.count)];
}

- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        if (self[i] == anObject) {
            [indexSet addIndex:i];
        }
    }
    
    [self removeObjectsAtIndexes:indexSet];
}

- (void)removeObjectIdenticalTo:(id)anObject;
{
    [self removeObjectIdenticalTo:anObject inRange:NSMakeRange(0, self.count)];
}

- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;
{
    NSUInteger lastIndex = NSNotFound;
    
    while ((lastIndex = [indexes indexLessThanIndex:lastIndex]) != NSNotFound) {
        [self removeObjectAtIndex:lastIndex];
    }
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
{
    if (idx == self.count) {
        [self addObject:obj];
    } else {
        [self replaceObjectAtIndex:idx withObject:obj];
    }
}

@end
