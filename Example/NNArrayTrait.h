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

#import "NNComprehensibleTrait.h"


@protocol NNArrayTrait <NSObject, NSFastEnumeration, NNComprehensibleTrait>

@required
- (instancetype)initWithArray:(NSArray *)array;
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;

@optional

#pragma mark Selected NSExtendedArray methods for example purposes
- (NSString *)componentsJoinedByString:(NSString *)separator;
- (BOOL)containsObject:(id)anObject;
- (NSString *)description;
- (NSUInteger)indexOfObject:(id)anObject;
- (NSUInteger)indexOfObject:(id)anObject inRange:(NSRange)range;
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject;
- (NSUInteger)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (BOOL)isEqualToArray:(NSArray *)otherArray;
- (id)firstObject;
- (id)lastObject;
- (NSArray *)subarrayWithRange:(NSRange)range;

#pragma mark Object subscripting
- (id)objectAtIndexedSubscript:(NSUInteger)index;

#pragma mark NSFastEnumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;

@end


// Making this work statically requires changes to the toolchain. For now: hardcode all the things!
@protocol NNTaggedArrayTrait <NNArrayTrait>

@optional

#pragma mark Selected NSExtendedArray methods for example purposes
- (NSString *)NNArrayTrait_componentsJoinedByString:(NSString *)separator;
- (BOOL)NNArrayTrait_containsObject:(id)anObject;
- (NSString *)NNArrayTrait_description;
- (NSUInteger)NNArrayTrait_indexOfObject:(id)anObject;
- (NSUInteger)NNArrayTrait_indexOfObject:(id)anObject inRange:(NSRange)range;
- (NSUInteger)NNArrayTrait_indexOfObjectIdenticalTo:(id)anObject;
- (NSUInteger)NNArrayTrait_indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (BOOL)NNArrayTrait_isEqualToArray:(NSArray *)otherArray;
- (id)NNArrayTrait_firstObject;
- (id)NNArrayTrait_lastObject;
- (NSArray *)NNArrayTrait_subarrayWithRange:(NSRange)range;

#pragma mark Object subscripting
- (id)NNArrayTrait_objectAtIndexedSubscript:(NSUInteger)index;

#pragma mark NSFastEnumeration
- (NSUInteger)NNArrayTrait_countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;

@end

