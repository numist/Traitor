//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NNArrayTrait.h"

@protocol NNMutableArrayTrait <NNArrayTrait>

@required
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;

@optional

#pragma mark Methods required by NSMutableArray but implemented by this trait anyway.
- (void)addObject:(id)anObject;
- (void)removeLastObject;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;

#pragma mark Selected NSExtendedMutableArray methods for example purposes
- (void)addObjectsFromArray:(NSArray *)otherArray;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)removeAllObjects;
- (void)removeObject:(id)anObject inRange:(NSRange)range;
- (void)removeObject:(id)anObject;
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsAtIndexes:(NSIndexSet *)indexes;

#pragma mark Object subscripting
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end


// Making this work statically requires changes to the toolchain. For now: hardcode all the things!
@protocol NNTaggedMutableArrayTrait <NNMutableArrayTrait>

@optional

- (void)NNMutableArrayTrait_addObject:(id)anObject;
- (void)NNMutableArrayTrait_removeLastObject;
- (void)NNMutableArrayTrait_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)NNMutableArrayTrait_addObjectsFromArray:(NSArray *)otherArray;
- (void)NNMutableArrayTrait_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)NNMutableArrayTrait_removeAllObjects;
- (void)NNMutableArrayTrait_removeObject:(id)anObject inRange:(NSRange)range;
- (void)NNMutableArrayTrait_removeObject:(id)anObject;
- (void)NNMutableArrayTrait_removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)NNMutableArrayTrait_removeObjectIdenticalTo:(id)anObject;
- (void)NNMutableArrayTrait_removeObjectsAtIndexes:(NSIndexSet *)indexes;

#pragma mark Object subscripting
- (void)NNMutableArrayTrait_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

@end
