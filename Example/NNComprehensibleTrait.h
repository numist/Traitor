//  Created by Scott Perry on 04/22/14.
//  Copyright © 2014 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>


typedef BOOL (^filter_block_t)(id item);
typedef id (^map_block_t)(id item);
typedef id (^reduce_block_t)(id accumulator, id item);


@protocol NNComprehensibleTrait <NSObject, NSFastEnumeration>

@required
- (instancetype)initWithArray:(NSArray *)array;

@optional

- (instancetype)filter:(filter_block_t)block;
- (instancetype)map:(map_block_t)block;
- (id)reduce:(reduce_block_t)block;

@end


// These are installed by the traits runtime on classes that use this trait, so as to provide an unambiguous reference to trait-provided implementations in the event of a conflict.
@protocol NNTaggedComprehensibleTrait <NNComprehensibleTrait>

@optional

- (instancetype)NNComprehensibleTrait_filter:(filter_block_t)block;
- (instancetype)NNComprehensibleTrait_map:(map_block_t)block;
- (id)NNComprehensibleTrait_reduce:(reduce_block_t)block;

@end

