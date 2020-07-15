const base_url = 'https://flutter.ikuer.cn/';      // baserUrl接口

const path = {
  'swiperData':base_url + 'banner',                         // 轮播图数据
  'uploadFile':base_url + 'upload',                         // 上传图片 
  'getUserCode':base_url + 'vcode',                         // 获取验证码
  'login':base_url +'login',                                // 登录
  'tasklist':base_url +'task/list',                         // 订单大厅
  'addOrder':base_url + 'task/release',                     // 发布订单
  'orderDetails':base_url + 'task/detail',                  // 发布订单
  'applyOrder':base_url + 'task/apply',                     // 申请任务
  'driverAuth':base_url + 'driver/auth',                    // 获取司机信息
  'postAuth':base_url + 'driver/auth',                      // 提交认证
  'userInfo':base_url + 'user/index',                       // 个人中心
  'employerInfo':base_url + 'employer/index',               // 雇主中心
  'driverInfo':base_url + 'driver/index',                   // 司机中心
  'modifyUserImage':base_url + 'user/head_pic',             // 头像修改
  'modifyUserName':base_url + 'user/nickname',              // 昵称修改
  'modifyUserPhone':base_url + 'user/phone',                // 手机号修改
  'taskListAll':base_url + 'employer/task_list',            // 查看任务
  'taskRefresh':base_url + 'task/refresh',                  // 刷新任务
  'taskStart':base_url + 'task/start',                      // 开始任务
  'taskEnd':base_url + 'task/complete',                     // 结束任务
  'taskCancel':base_url + 'task/cancel',                       // 取消任务
  'taskDrivers':base_url + 'task/drivers',                     // 查看司机列表
  'applyAgree':base_url + 'apply/agree',                       // 同意申请
  'applyRefuse':base_url + 'apply/refuse',                     // 拒绝申请
  'applyListAll':base_url + 'driver/apply_list',               // 获取全部申请
  'applyDividerCancel':base_url + 'driver/cancel',             // 撤销申请
  'appraise':base_url + 'driver/appraise',                     // 司机评论雇主
  'search':base_url + 'task/search',                            // 搜索
  'userAppraise':base_url + 'employer/appraise',                // 雇主评论司机
  'aliPay':base_url + 'alipay/app_pay',                         // 支付宝支付
  'update':base_url + 'app/update',                             // App更新
  'bill':base_url + '/wallet/bill',                             // 账单记录
  'add_recruit':base_url + '/recruit/release',                  // 发布招聘    
  'recruit_list':base_url + '/recruit/recruit_list',            // 招聘大厅
  'home_recruit':base_url + '/recruit/home_recruit',            // 首页6条招聘信息
  'my_recruitList':base_url + '/recruit/my_recruit',            // 我的招聘
  'delete_recruit':base_url + '/recruit/delete',                // 删除招聘
  'detail_recruit':base_url + '/recruit/detail',                // 全部详情
  'my_detail_recruit':base_url + '/recruit/my_recruit_detail',  // 我的详情
  'userImage':base_url + '/user/get_user_base',                 // 用户头像
  'month_limit':base_url + '/user/month_pay',                   // 月交易额
  'notifyList':base_url + '/notify/notify_list',                // 通知列表
  'notifyDetail':base_url + '/notify/detail',                   // 通知列表详情

  // 聊天接口
  'isVip':base_url+'/user/is_vip',                                      // 判断是否为VIP
  'vip_list':base_url + '/chat/viper_list',                             // VIP列表
  'lastest_contacts':base_url + '/chat/lastest_contacts',               // VIP列表
  'viper_history_message':base_url+'/chat/viper_history_message',       // VIP聊天记录
  'history_message':base_url+'/chat/history_message',                   // 普通聊天记录
  'read_status':base_url+'/chat/read_status',                            // 标记已读
  'getMessageList':base_url + '/im/dialogue_userinfo'           // 获取聊天列表的信息

};

const jd_url = 'http://jd.itying.com/';         // 京东测试接口

const jd_path = {
  'productList' :jd_url + 'api/pcontent'        // 京东商品详情接口
};


const news_url = 'http://ic.snssdk.com/';       // 新闻头条接口

const news_path = {
  'getNews': news_url + '2/article/v25/stream/'       // 获取头条
};