//
//  ResultModel.h
//  
//
//  Created by Lee on 6/10/16.
//
//

#import <Realm/Realm.h>
#import "DateTools.h"
@interface ResultModel : RLMObject
@property (nonatomic,strong)NSString *resultString;
@property (nonatomic,strong)NSDate *date;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ResultModel>
RLM_ARRAY_TYPE(ResultModel)
