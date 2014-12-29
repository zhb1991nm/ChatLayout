//
//  ITcpClient.h
//  ConnectTest
//
//  Created by icode on 14/12/23.
//  Copyright (c) 2014年 sinitek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TcpClientDelegate <NSObject>

#pragma mark ITcpClient

/**发送到服务器端的数据*/
-(void)OnSendDataSuccess:(NSString*)sendedTxt;

/**收到服务器端发送的数据*/
-(void)OnReciveData:(NSString*)recivedTxt;

/**socket连接出现错误*/
-(void)OnConnectionError:(NSError *)err;


/**
 *  当成功连接服务器
 */
-(void)didConnectToHost;

/**
 *  当socket连接服务器失败
 *
 *  @param err
 */

-(void)onConnectToHostError:(NSError *)err;

/**
 *  当socket断开连接
 *
 *  @param err
 */
-(void)onDisConnect:(NSError *)err;

@end
