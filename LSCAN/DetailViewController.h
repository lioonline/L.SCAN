//
//  DetailViewController.h
//  LSCAN
//
//  Created by Lee on 6/10/16.
//  Copyright © 2016 Lee. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^hidden)(void);

@interface DetailViewController : BaseViewController
@property (nonatomic,strong)hidden hiddenBlock;
-(id)initWithContent:(NSString *)content;

@end
