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


@protocol NNSetTrait <NSObject, NSFastEnumeration, NNComprehensibleTrait>

@required
- (instancetype)initWithArray:(NSArray *)array;
- (NSUInteger)count;
- (id)member:(id)object;
- (NSEnumerator *)objectEnumerator;

@optional

#pragma mark Selected NSExtendedSet methods for example purposes
- (NSArray *)allObjects;
- (id)anyObject;
- (BOOL)containsObject:(id)anObject;
- (NSString *)description;
- (BOOL)intersectsSet:(id<NNSetTrait>)otherSet;
- (BOOL)isEqualToSet:(id<NNSetTrait>)otherSet;
- (BOOL)isSubsetOfSet:(id<NNSetTrait>)otherSet;

- (instancetype)setByUnionWithSet:(id<NNSetTrait>)otherSet;
- (instancetype)setByRemovingFromSet:(id<NNSetTrait>)otherSet;
- (instancetype)setByIntersectionWithSet:(id<NNSetTrait>)otherSet;

@end


// These are installed by the traits runtime on classes that use this trait, so as to provide an unambiguous reference to trait-provided implementations in the event of a conflict.
@protocol NNTaggedSetTrait <NNSetTrait>

@optional

#pragma mark Selected NSExtendedSet methods for example purposes
- (NSArray *)NNSetTrait_allObjects;
- (id)NNSetTrait_anyObject;
- (BOOL)NNSetTrait_containsObject:(id)anObject;
- (NSString *)NNSetTrait_description;
- (BOOL)NNSetTrait_intersectsSet:(id<NNSetTrait>)otherSet;
- (BOOL)NNSetTrait_isEqualToSet:(id<NNSetTrait>)otherSet;
- (BOOL)NNSetTrait_isSubsetOfSet:(id<NNSetTrait>)otherSet;

- (instancetype)NNSetTrait_setByUnionWithSet:(id<NNSetTrait>)otherSet;
- (instancetype)NNSetTrait_setByRemovingFromSet:(id<NNSetTrait>)otherSet;
- (instancetype)NNSetTrait_setByIntersectionWithSet:(id<NNSetTrait>)otherSet;

@end

