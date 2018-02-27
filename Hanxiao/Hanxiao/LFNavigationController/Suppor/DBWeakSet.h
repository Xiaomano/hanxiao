//
//  DBWeakArray.h
//  DataBinding
//
//  Created by 福有李 on 17/6/26.
//  Copyright © 2017年 福有李. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBWeakSet<ObjectType> : NSObject <NSFastEnumeration>

@property (nonatomic,assign,readonly) NSUInteger count;
@property (nonatomic,readonly) NSArray *allObjects;
-(void)addObject:(ObjectType)object;
-(void)removeObject:(ObjectType)object;
- (NSUInteger)indexOfObject:(ObjectType)anObject;

@end
