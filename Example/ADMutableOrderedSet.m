//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ADMutableOrderedSet.h"

#import "ADMutableArray.h"
#import "ADMutableSet.h"


@interface ADMutableOrderedSet () <NNTaggedMutableArrayTrait, NNTaggedArrayTrait, NNTaggedSetTrait>

@property (nonatomic, strong) ADMutableArray *backingArray;
@property (nonatomic, strong) ADMutableSet *backingSet;

@end


@implementation ADMutableOrderedSet

- (instancetype)init;
{
    if (!(self = [super init])) { return nil; }
    
    self->_backingArray = [ADMutableArray new];
    self->_backingSet = [ADMutableSet new];
    
    return self;
}

#pragma mark NNArrayTrait

- (instancetype)initWithArray:(NSArray *)array;
{
    if (!(self = [self init])) { return nil; }
    
    for (id object in array) {
        [self addObject:object];
    }
    
    return self;
}

- (NSUInteger)count;
{
    return self.backingArray.count;
}

- (id)objectAtIndex:(NSUInteger)index;
{
    return [self.backingArray objectAtIndex:index];
}

#pragma mark NNMutableArrayTrait

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;
{
    if ([self.backingSet containsObject:anObject]) { return; }

    [self.backingArray insertObject:anObject atIndex:index];
    [self.backingSet addObject:anObject];
}

- (void)removeObjectAtIndex:(NSUInteger)index;
{
    id object = self.backingArray[index];
    [self.backingArray removeObjectAtIndex:index];
    [self.backingSet removeObject:object];
}

#pragma mark NNSetTrait

// -initWithArray: was already implemented as part of the NNArrayTrait section

// -count was already implemented as part of the NNArrayTrait section

- (id)member:(id)object;
{
    return [self.backingSet member:object];
}

- (NSEnumerator *)objectEnumerator;
{
    return [self.backingSet objectEnumerator];
}

#pragma mark NNMutableSetTrait

- (void)addObject:(id)object;
{
    if ([self.backingSet containsObject:object]) { return; }
    
    [self.backingSet addObject:object];
    [self.backingArray addObject:object];
}

- (void)removeObject:(id)object;
{
    [self.backingSet removeObject:object];
    [self.backingArray removeObject:object];
}

#pragma mark Conflicts resolved with NNMutableArrayTrait

- (void)addObjectsFromArray:(NSArray *)otherArray;
{
    [self NNMutableArrayTrait_addObjectsFromArray:otherArray];
}

- (void)removeAllObjects;
{
    [self NNMutableArrayTrait_removeAllObjects];
}

#pragma mark Conflicts resolved with NNArrayTrait

- (NSString *)description;
{
    return [self NNArrayTrait_description];
}

#pragma mark Conflicts resolved with NNSetTrait

- (BOOL)containsObject:(id)anObject;
{
    return [self NNSetTrait_containsObject:anObject];
}

#pragma mark Conflicts resolved with override

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
{
    return [self.backingArray countByEnumeratingWithState:state objects:buffer count:len];
}

@end
