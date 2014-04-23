//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ADPriorityQueue.h"


@interface ADPriorityQueue ()

@property (nonatomic, strong) NSMutableArray *backingStore;

@end


@implementation ADPriorityQueue

- (instancetype)init;
{
    if (!(self = [super init])) { return nil; }
    
    self->_backingStore = [NSMutableArray new];
    
    return self;
}

#pragma mark NNArrayTrait

- (instancetype)initWithArray:(NSArray *)array;
{
    if (!(self = [self init])) { return nil; }
    
    for (id object in array) {
        [self insertObject:object];
    }
    
    return self;
}

- (NSUInteger)count;
{
    return self.backingStore.count;
}

- (id)objectAtIndex:(NSUInteger)index;
{
    return [self.backingStore objectAtIndex:index];
}

#pragma mark ADPriorityQueue

- (void)insertObject:(id<ADPriorityObject>)object;
{
    NSUInteger insertionIndex = [self.backingStore indexOfObject:object
                                                   inSortedRange:NSMakeRange(0, self.count)
                                                         options:NSBinarySearchingInsertionIndex
                                                 usingComparator:^(id<ADPriorityObject> obj1, id<ADPriorityObject> obj2) {

        return (NSComparisonResult)[@(obj1.priority) compare:@(obj2.priority)];
    }];
    [self.backingStore insertObject:object atIndex:insertionIndex];
}

- (void)removeObjectAtIndex:(NSUInteger)index;
{
    [self.backingStore removeLastObject];
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
{
    return [self.backingStore countByEnumeratingWithState:state objects:buffer count:len];
}

@end
