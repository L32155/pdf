//
//  TodaySuggestView.m
//  XTReader
//
//  Created by gao7 on 15/12/2.
//  Copyright © 2015年 gao7. All rights reserved.
//

#import "TodaySuggestView.h"
#import "NovelModel.h"
#import "NovelObject.h"
#import "BookStoreTableViewCell.h"

@interface TodaySuggestView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSArray *novelArray;

@end

@implementation TodaySuggestView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addView];
//        [self addTestArray];
    }
    return self;
}

//- (void)addTestArray {
//    NovelObject *obj = [[NovelObject alloc] initWithTitle:@"test" code:@"121"];
//    NovelObject *obj1 = [[NovelObject alloc] initWithTitle:@"test1" code:@"1212"];
//    _novelArray = [NSArray arrayWithObjects:obj,obj1, nil];
//}

- (void)addView {
    self.autoresizesSubviews = YES;
    _tableView = [[UITableView alloc] init];
    
//    [_tableView setNeedsUpdateConstraints];
//    [_tableView updateConstraintsIfNeeded];
//    _tableView.autoresizesSubviews = NO;
    _tableView.autoresizingMask = UIViewAutoresizingNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.backgroundColor = [UIColor purpleColor];
    [self addSubview:_tableView];
//    self.backgroundColor = [UIColor purpleColor];
    [self initData];
    
}

- (void)updateConstraints {
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
        make.top.left.and.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-64);
    }];
    [super updateConstraints];
    
}

- (void)refresh {
//    [self addView];
//    [self setNeedsUpdateConstraints];
}

- (void)initData {
    
    NovelModel *novelModel = [[NovelModel alloc] init];
    
    __weak __typeof(&*self) weakSelf = self;
    [novelModel setCompleteBlock:^(NSDictionary *dic,BOOL isSuccess) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        
        strongSelf.novelArray = [DataTypeHelper parseNovelObjectType:dic];
        [strongSelf.tableView reloadData];
    }];
    NSString *url=[NSString stringWithFormat:@"http://japi.juhe.cn/book/recommend.from?key=%@&cat=1&ranks=0",AppKey];
//     NSString *testurl=[NSString stringWithFormat:@"http://v.juhe.cn/weixin/query?pno=1&ps=20&dtype=&key=7b44f3619becc07a284ad46e158ed08a"];

    [novelModel loadWithUrl:url];
    
//    _novelArray = [novelModel getNovelArrayWithAppKey:AppKey cat:1 ranks:0];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _novelArray.count;
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NovelObject *novelObject;
    novelObject = [_novelArray objectAtIndex:indexPath.row];
    static NSString *identifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//    }
//    cell.textLabel.text = novelObject.title;
//    cell.textLabel.text = @"test";
//    return cell;
    BookStoreTableViewCell *bookcell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (bookcell == nil) {
        bookcell = [[BookStoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    [bookcell setNovelImage:[UIImage imageNamed:@"test2.png"] title:@"test"];
    [bookcell setNovelImage:[UIImage imageNamed:@"test2.png"] title:novelObject.title];
    return bookcell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NovelObject *novelObject;
    novelObject = [_novelArray objectAtIndex:indexPath.row];
    NSLog(@"select me");
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidSelect:)]) {
        [self.delegate cellDidSelect:novelObject];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
