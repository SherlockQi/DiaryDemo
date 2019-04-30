//
//  HKEditDiaryViewController.m
//  MyBeautifulLife
//
//  Created by 夏琪 on 2018/9/9.
//  Copyright © 2018年 HeiKki. All rights reserved.
//

#import "HKEditDiaryViewController.h"
#import "HKDiaryTextCell.h"
#import "HKDiaryImageCell.h"
#import "HKDiaryDetailModel.h"
#import <QMUIKit/QMUIKit.h>
#import "HKEditTextView.h"


#define kPlaceHolder @"点击插入文字/图片"
@interface HKEditDiaryViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HKDiaryDetailModel *> *diaryModels;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) HKEditTextView *editTextView;
@property (nonatomic, strong) UIView *coverView;
@end

@implementation HKEditDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写日记";
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 200;
    self.diaryModels = [NSMutableArray arrayWithCapacity:10];
    
    HKDiaryDetailModel *model = [HKDiaryDetailModel modelWithContent: kPlaceHolder type:@"text" heightScale:0];
    self.editTextView = [[NSBundle mainBundle] loadNibNamed:@"HKEditTextView" owner:self options:nil].firstObject;
    self.editTextView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
    [self.diaryModels addObject:model];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"HKDiaryImageCell" bundle:nil] forCellReuseIdentifier:@"HKDiaryImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HKDiaryTextCell" bundle:nil] forCellReuseIdentifier:@"HKDiaryTextCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    [self.view addSubview:self.coverView];
    [self.coverView addSubview:self.editTextView];

    
    [self configRightButton];
}

- (void)configRightButton{
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.tintColor = kColor_mainPink;
    [rightButton addTarget:self action:@selector(rightButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)editButtonDidClick:(id)sender {
    
    HKDiaryDetailModel *model = self.diaryModels[_selectIndex];
    NSString *text  = self.editTextView.textView.text;
    if ([model.type isEqualToString:@"text"]) {
        if (![text isEqualToString: kPlaceHolder] && ![text isEqualToString: @""]) {
            model.content = text;
        }
    }else{
        HKDiaryDetailModel *m = [HKDiaryDetailModel modelWithContent:text type:@"text" heightScale:0];
        [self.diaryModels insertObject:m atIndex:_selectIndex + 1];
    }
    [_editTextView endEditing:YES];
    [self.tableView reloadData];
}

- (void)rightButtonDidClick:(UIButton *)button{
    NSLog(@"保存");
    
}

#pragma <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.diaryModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HKDiaryDetailModel *model = self.diaryModels[indexPath.row];
    
    if ([model.type isEqualToString:@"text"]) {
        HKDiaryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKDiaryTextCell"];
        cell.contentLabel.text = model.content;
        return cell;
    }else{
        HKDiaryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HKDiaryImageCell"];
        cell.contentImageView.image = model.image;
        return cell;
    };
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HKDiaryDetailModel *model = self.diaryModels[indexPath.row];
    
    return [model.type isEqualToString:@"text"] ? UITableViewAutomaticDimension : (kScreenWidth - 30) * model.heightScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
     __weak typeof(self) weakSelf = self;
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    
    
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"插入文字" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        if ([weakSelf.diaryModels[indexPath.row].content isEqualToString: kPlaceHolder]) {
            weakSelf.editTextView.textView.text = @"";
        }else{
            weakSelf.editTextView.textView.text = weakSelf.diaryModels[indexPath.row].content;
        }
        [weakSelf.editTextView.textView becomeFirstResponder];
    }];
    
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"插入图片" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf pickerImage];
    }];
    
    QMUIAlertAction *action4 = [QMUIAlertAction actionWithTitle:@"删除条目" style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        [weakSelf.diaryModels removeObjectAtIndex:weakSelf.selectIndex];
        [weakSelf.tableView reloadData];
    }];
    
    QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:@"操作" message:@"请选择您要执行的操作" preferredStyle:QMUIAlertControllerStyleActionSheet];
    NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetTitleAttributes];
    titleAttributs[NSForegroundColorAttributeName] = UIColorWhite;
    
    alertController.sheetTitleAttributes = titleAttributs;
    NSMutableDictionary *messageAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetMessageAttributes];
    messageAttributs[NSForegroundColorAttributeName] = UIColorWhite;
    alertController.sheetMessageAttributes = messageAttributs;
    alertController.sheetHeaderBackgroundColor = kColor_mainPink;
    alertController.sheetSeparatorColor = K_E3E3E3_COLOR;
    
    NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetButtonAttributes];
    buttonAttributes[NSForegroundColorAttributeName] = alertController.sheetHeaderBackgroundColor;
    alertController.sheetButtonAttributes = buttonAttributes;
    
    NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetCancelButtonAttributes];
    cancelButtonAttributes[NSForegroundColorAttributeName] = buttonAttributes[NSForegroundColorAttributeName];
    alertController.sheetCancelButtonAttributes = buttonAttributes;
    
    NSMutableDictionary *deleteAttributes = [[NSMutableDictionary alloc]initWithDictionary:@{NSForegroundColorAttributeName : kColor_9}];
    [alertController setSheetDestructiveButtonAttributes:deleteAttributes];
    
    
    [alertController addAction:action3];
    [alertController addAction:action1];
    [alertController addAction:action2];
    if (self.diaryModels.count > 1) {
        [alertController addAction:action4];
    }
    [alertController showWithAnimated:YES];
}

- (void)pickerImage{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.navigationBar.barTintColor = kColor_mainPink;
    imagePickerController.navigationBar.tintColor = [UIColor whiteColor];
    [imagePickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGFloat heightScale = image.size.height / image.size.width;
    HKDiaryDetailModel *model = [HKDiaryDetailModel modelWithContent: @"" type:@"image" heightScale:heightScale];
    model.image = image;
    
    if ([self.diaryModels.firstObject.content isEqualToString:kPlaceHolder]) {
        [self.diaryModels replaceObjectAtIndex:0 withObject:model];
    }else{
        [self.diaryModels insertObject:model atIndex:self.selectIndex + 1];
    }
    
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification{
    _coverView.alpha = 1;
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
     __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.editTextView.frame = CGRectMake(0, kScreenHeight - 200 - frame.size.height, kScreenWidth, 200);
        weakSelf.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
}

- (void)keyboardWillBeHiden:(NSNotification *)notification{
     __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        self.editTextView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 200);
        weakSelf.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    } completion:^(BOOL finished) {
        weakSelf.coverView.alpha = 0;
    }];
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        _coverView.alpha = 0;
    };
    return _coverView;
}

@end
