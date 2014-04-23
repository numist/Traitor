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

#import <Traitor/Traitor.h>


@interface NNArrayTrait : TRTrait <NNArrayTrait>
@end


@implementation NNArrayTrait

- (NSUInteger)count;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
}

- (id)objectAtIndex:(NSUInteger)index;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
}

- (NSString *)componentsJoinedByString:(NSString *)separator;
{
    NSString *result = [[self firstObject] description];
    
    if (self.count > 1) {
        for (id object in [self subarrayWithRange:NSMakeRange(1, self.count - 1)]) {
            result = [NSString stringWithFormat:@"%@%@%@", result, separator, [object description]];
        }
    }
    
    return result;
}

- (BOOL)containsObject:(id)anObject;
{
    for (id item in self) {
        if ([item isEqual:anObject]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSString *)description;
{
    return [[self subarrayWithRange:NSMakeRange(0, self.count)] description];
}

- (NSUInteger)indexOfObject:(id)anObject;
{
    return [self indexOfObject:anObject inRange:NSMakeRange(0, self.count)];
}

- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range;
{
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        if ([self[i] isEqual:anObject]) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject;
{
    return [self indexOfObjectIdenticalTo:anObject inRange:NSMakeRange(0, self.count)];
}

- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
{
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        if (self[i] == anObject) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (BOOL)isEqualToArray:(NSArray *)otherArray;
{
    return [[self subarrayWithRange:NSMakeRange(0, self.count)] isEqualToArray:otherArray];
}

- (id)firstObject;
{
    if (self.count) {
        return self[0];
    }
    
    return nil;
}

- (id)lastObject;
{
    if (self.count) {
        return self[self.count - 1];
    }
    
    return nil;
}

- (NSArray *)subarrayWithRange:(NSRange)range;
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:range.length];
    
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        [result addObject:self[i]];
    }
    
    return result;
}

- (id)objectAtIndexedSubscript:(NSUInteger)index;
{
    return [self objectAtIndex:index];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;
{
    NSUInteger i, count;
    for (i = state->state, count = 0; i < self.count && count < len; count++, i++) {
        buffer[i] = self[i];
    }
    
    state->state = i;
    state->itemsPtr = buffer;
    // Sorry, but I have no intrinsic state variables.
    state->mutationsPtr = (__bridge void *)self;
    
    return count;
}

@end
