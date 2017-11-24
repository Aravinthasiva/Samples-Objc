//
//  WebServices.h

//  Created by Jack on 14/02/17.


#import <Foundation/Foundation.h>


#define TAG_LOGIN 1
#define TAG_USER_DEATILS 2
#define TAG_PENDING_REQUEST 3

#define TAG_SAVEROUTINE 78



//TEST FEEDS
#define LOGIN_URL @""
#define USERDETAIL_URL @""
#define REQUEST_URL @""




@class WebServices;
@protocol WebServicesDelegate <NSObject>

@optional
- (void)receivedResponse:(NSDictionary *)dictResponse;

@optional
- (void)receivedResponse:(NSDictionary *)dictResponse fromWebservice:(WebServices *) webservice;

@optional
- (void)receivedError:(NSString *)error fromWebservice:(WebServices *) webservice;

@end


@interface WebServices : NSObject <NSXMLParserDelegate>
{
    id delegate;
    NSMutableData *responseData;
    NSString *strURL;
}

@property (nonatomic,assign) int tag;
@property (nonatomic, retain) id delegate;

- (void)getDataFromURL:(NSString *)url;
- (void) postDataWithString:(NSString *)url withArguments:(NSString *)strPost;
-(void)getData : (NSString *)strGet;


@end
