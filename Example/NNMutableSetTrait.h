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

@protocol NNMutableSetTrait <NNSetTrait>

@required
- (void)addObject:(id)object;
- (void)removeObject:(id)object;

@optional

#pragma mark Selected NSExtendedMutableSet methods for example purposes
- (void)addObjectsFromArray:(NSArray *)array;
- (void)intersectSet:(NSSet *)otherSet;
- (void)minusSet:(NSSet *)otherSet;
- (void)removeAllObjects;
- (void)unionSet:(NSSet *)otherSet;
- (void)setSet:(NSSet *)otherSet;

@end


// Making this work statically requires changes to the toolchain. For now: hardcode all the things!
@protocol NNTaggedMutableSetTrait <NNMutableSetTrait>

@optional

#pragma mark Selected NSExtendedMutableSet methods for example purposes
- (void)NNMutableSetTrait_addObjectsFromArray:(NSArray *)array;
- (void)NNMutableSetTrait_intersectSet:(NSSet *)otherSet;
- (void)NNMutableSetTrait_minusSet:(NSSet *)otherSet;
- (void)NNMutableSetTrait_removeAllObjects;
- (void)NNMutableSetTrait_unionSet:(NSSet *)otherSet;
- (void)NNMutableSetTrait_setSet:(NSSet *)otherSet;

@end
