//
//  QMPaymentViewController.m
//  PayPlusSDKDemo
//
//  Created by Sam Pan on 018/04/2017.
//  Copyright © 2017 com.yeepay.payplus. All rights reserved.
//

#import "QMPaymentViewController.h"
#import <AFNetworking.h>
#import "PayPlusCore.h"

@interface QMPaymentViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataListEnv;  //支付环境
@property (strong, nonatomic) NSMutableArray *dataListCha;  //支付方式

@property (strong, nonatomic) UIActivityIndicatorView    *activityIndicator;

@property (weak,   nonatomic) UIScrollView   *scrollView;
@property (weak,   nonatomic) UITableView    *tableView;
@property (weak,   nonatomic) UITextField    *tfPayAmount;
@property (weak,   nonatomic) UIButton       *btnCommit;

@property (assign, nonatomic) NSUInteger  selectedRowEnv;
@property (assign, nonatomic) NSUInteger  selectedRowCha;

@end

@implementation QMPaymentViewController

- (UIActivityIndicatorView *)activityIndicator{
    if(_activityIndicator == nil){
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_activityIndicator setFrame:CGRectMake(0, 0, 30, 30)];
        [_activityIndicator setColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.8]];
        [_activityIndicator setHidesWhenStopped:YES];
        [_activityIndicator stopAnimating];
    }
    return _activityIndicator;
}

- (NSMutableArray *)dataListEnv{
    if(_dataListEnv == nil){
        _dataListEnv = [NSMutableArray array];
        [_dataListEnv addObject:@"QA环境"];
        [_dataListEnv addObject:@"生产环境"];
    }
    return _dataListEnv;
}

- (NSMutableArray *)dataListCha{
    if(_dataListCha == nil){
        _dataListCha = [NSMutableArray array];
        [_dataListCha addObject:@"微信支付"];
        [_dataListCha addObject:@"阿里支付"];
    }
    return _dataListCha;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"钱麦支付测试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeUI];
}

- (void)initializeUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 100)];
    [scrollView setScrollEnabled:YES];
    [scrollView setPagingEnabled:NO];
    [scrollView setBackgroundColor:[UIColor colorWithRed:227/255.0f green:227/255.0f blue:229/255.0f alpha:1.0]];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 310)];
    //[tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)]];
    [tableView setDataSource:(id)self];
    [tableView setDelegate:(id)self];
    [tableView setScrollEnabled:NO];
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *btnCommit = [[UIButton alloc] init];
    [btnCommit setFrame:CGRectMake(25, 350, [UIScreen mainScreen].bounds.size.width - 50, 40)];
    [btnCommit setTitle:@"支付" forState:UIControlStateNormal];
    [btnCommit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCommit setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.8]];
    [btnCommit setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.8]];
    [btnCommit.layer setMasksToBounds:YES];
    [btnCommit.layer setCornerRadius:5];
    [btnCommit addTarget:self action:@selector(btnCommitDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btnCommit];
    
    //1.设置导航栏的进度视图
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, backItem];
}

#pragma mark --数据代理方法区域--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSUInteger count = (section == 0) ? 2 :
                       (section == 1) ? 1 :
                       (section == 2) ? 2 : 0 ;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    static NSString *identifier = @"ViewController";
    UITableViewCell *cell = nil;
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"tdViewController"];
    } else{
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    
    if (cell == nil) {
        if (indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tdViewController"];
        } else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (indexPath.section == 0) {
        [cell.textLabel setText:self.dataListEnv[indexPath.row]];
    } else if (indexPath.section == 1) {
        [cell.textLabel setText:@"支付金额"];
    } else if (indexPath.section == 2) {
        [cell.textLabel setText:self.dataListCha[indexPath.row]];
    } else{
        
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
    
    if (![cell viewWithTag:128]) {
        if (indexPath.section != 1) {
            UIImage *image = [UIImage imageNamed: (indexPath.row == 0) ? @"button_select_selected" : @"button_select_normal" ];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 35, 12, 20, 20)];
            [imageView setTag:128];
            [cell addSubview:imageView];
        }else{
            UITextField *tfPayAmount = [[UITextField alloc] init];
            [tfPayAmount setFrame:CGRectMake(75, 7, [UIScreen mainScreen].bounds.size.width - 90, 30)];
            [tfPayAmount setPlaceholder:@"请输入金额"];
            [tfPayAmount setText:@"0.01"];
            [tfPayAmount setKeyboardType:UIKeyboardTypeDecimalPad];
            //[tfPayAmount setBackgroundColor:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0]];
            [tfPayAmount setTintColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0]];
            [tfPayAmount setTextAlignment:NSTextAlignmentRight];
            [tfPayAmount.layer setMasksToBounds:YES];
            [tfPayAmount.layer setCornerRadius:5];
            [tfPayAmount setTag:128];
            [cell addSubview:tfPayAmount];
            self.tfPayAmount = tfPayAmount;
        }
    }else{
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:128];
        
        if (indexPath.section == 0) {
            if (self.selectedRowEnv == indexPath.row) {
                [imageView setImage:[UIImage imageNamed:@"button_select_selected"]];
            }else{
                [imageView setImage:[UIImage imageNamed:@"button_select_normal"]];
            }
        }
        
        if (indexPath.section == 2) {
            if (self.selectedRowCha == indexPath.row) {
                [imageView setImage:[UIImage imageNamed:@"button_select_selected"]];
            }else{
                [imageView setImage:[UIImage imageNamed:@"button_select_normal"]];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        self.selectedRowEnv = indexPath.row;
    } else if (indexPath.section == 2) {
        self.selectedRowCha = indexPath.row;
    }

    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = (section == 0) ? @"支付环境" :
                     (section == 1) ? @"支付金额" :
                     (section == 2) ? @"支付方式" : @"" ;
    return title;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0];
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1.0]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (void)btnCommitDidClicked:(UIButton *)button{
    
    if (self.tfPayAmount.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入金额" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.activityIndicator.isAnimating) {
        return;
    }
    
    //1. 用户去自己的商户后台下单
    NSString *strAmount = self.tfPayAmount.text;
    NSString *strChannal = self.selectedRowCha == 0 ? @"WECHATSDK" : @"ALIPAYSDK";
    NSString *strEnviroment = self.selectedRowEnv == 0 ? @"qa" : @"product";
    NSString *urlString = @"http://172.17.102.190:8014";        //用户自己的后台下单地址
    urlString = [urlString stringByAppendingFormat:@"/cashier-test/test/appPayPreparePay?env=%@&orderAmount=%@&payTool=%@",strEnviroment,strAmount,strChannal];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [self.activityIndicator startAnimating];
    NSLog(@"%@",urlString);
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.activityIndicator stopAnimating];
        NSLog(@"%@",responseObject);
        
        if ([responseObject objectForKey:@"payCharge"] &&
            [responseObject objectForKey:@"payChannal"]){
            
            //2. 下单完毕之后，自己唤醒支付工具进行支付(一行代码进行支付操作)
            NSString *appScheme = @"appscheme";
            [PayPlusCore PayPlusCoreStartToPayWithCharge:responseObject viewController:self appURLScheme:appScheme completionBlock:^(NSString *result, PayPlusError *error) {
                NSLog(@"ali | result = %@",result);
                NSLog(@"ali | errorCode = %lu",(unsigned long)error.errorChannalCode);
                if ([result isEqualToString:@"success"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付成功" message:@"您的订单支付成功." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }else{
                    switch (error.errorChannalCode) {
                        case PayPlusErrCancelled:{
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付取消" message:@"您的订单支付已取消." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                        }break;
                            
                        default:
                            break;
                    }
                }
            }];
        } else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"下单错误" message:((NSDictionary *)responseObject).description
                                                          delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.activityIndicator stopAnimating];
    }];
}

@end
