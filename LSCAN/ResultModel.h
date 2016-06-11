//
//  ResultModel.h
//  
//
//  Created by Lee on 6/10/16.
//
//

#import <Realm/Realm.h>

@interface ResultModel : RLMObject
@property (nonatomic,strong)NSString *resultString;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ResultModel>
RLM_ARRAY_TYPE(ResultModel)
