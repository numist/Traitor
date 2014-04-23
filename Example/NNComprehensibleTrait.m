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


@interface NNComprehensibleTrait : TRTrait <NNComprehensibleTrait>
@end


@implementation NNComprehensibleTrait

- (instancetype)initWithArray:(NSArray *)array;
{
    [self doesNotRecognizeSelector:_cmd];
    __builtin_unreachable();
}

- (instancetype)filter:(filter_block_t)block;
{
    NSMutableArray *resultArray = [NSMutableArray new];
    for (id object in self) {
        if (block(object)) {
            [resultArray addObject:object];
        }
    }
    return [[[self class] alloc] initWithArray:resultArray];
}

- (instancetype)map:(map_block_t)block;
{
    NSMutableArray *resultArray = [NSMutableArray new];
    for (id object in self) {
        [resultArray addObject:block(object)];
    }
    return [[[self class] alloc] initWithArray:resultArray];
}

- (id)reduce:(reduce_block_t)block;
{
    id accumulator = nil;
    for (id object in self) {
        accumulator = block(accumulator, object);
    }
    return accumulator;
}

@end
