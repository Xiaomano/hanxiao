//
//  DBWeakArray.m
//  DataBinding
//
//  Created by 福有李 on 17/6/26.
//  Copyright © 2017年 福有李. All rights reserved.
//

#import "DBWeakSet.h"

typedef id(^DBWeakBlock)();

@interface DBWeakSet (){
    NSMutableArray <DBWeakBlock>*_blockArray;
    unsigned long _mutationsPtr;
}

@end

@implementation DBWeakSet
- (instancetype)init
{
    self = [super init];
    if (self) {
        _blockArray = [NSMutableArray array];
    }
    
    return self;
}

-(NSUInteger)count{
    
    NSMutableArray *releases = [NSMutableArray array];
    [_blockArray enumerateObjectsUsingBlock:^(DBWeakBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [releases addObject:obj];
    }];
    [_blockArray removeObjectsInArray:releases];
    return _blockArray.count;
}

-(void)addObject:(id)object{
    
    __weak id wobject = object;
    if ([self indexOfObject:object] != NSNotFound) //保证对像唯一
        return;
    
    [_blockArray addObject:^(){
        return wobject;
    }];
}


-(NSArray *)allObjects{
    NSMutableArray *array = [NSMutableArray array];
    
    for (DBWeakBlock block in _blockArray) {
        NSObject *obj = block();
        if (obj != nil) {
            [array addObject:obj];
        }
    }
    
    return  array;
}
-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len{
    
    if (_blockArray.count < state->state) {
        return 0;
    }
    state->itemsPtr = buffer;
    state->mutationsPtr = &_mutationsPtr;
    
    NSInteger dlen = MAX(len, _blockArray.count); //猜测的最大值
    unsigned long count = 0; //初始给到的数量
    unsigned long j = state->state;
    for (count = 0; count < dlen ; j++) {
        
        if (j < _blockArray.count) {
            id obj = _blockArray[j]();
            
            if (obj != nil) {
                buffer[count] = obj;
                count++;
            }else{
                [_blockArray removeObjectAtIndex:j];
            }
        }else{
            break;
        }
    }
    state->state += count;
    return count;
}

-(void)removeObject:(id)object{
    
    DBWeakBlock blockHandle = nil;
    
    for (DBWeakBlock block in _blockArray) {
        if (block() == object) {
            blockHandle = block;
            break;
        }
    }
    if (blockHandle != nil) {
        [_blockArray removeObject:blockHandle];
    }
    
}

-(NSUInteger)indexOfObject:(id)anObject{
    NSInteger i = 0;
    for (DBWeakBlock block in _blockArray) {
        if (block() == anObject) {
            return i;
        }
        i++;
    }
    return NSNotFound;
}


@end
