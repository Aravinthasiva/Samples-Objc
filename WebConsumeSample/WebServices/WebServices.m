//
//  WebServices.m

//  Created by Jack on 14/02/17.


#import "WebServices.h"
#import "AppDelegate.h"

@implementation WebServices

@synthesize delegate;
@synthesize tag;

- (void)getDataFromURL:(NSString *)url
{
    strURL = [NSString stringWithString:url];
    responseData = [NSMutableData data];
    NSURL *baseURL = [NSURL URLWithString:url];
    // NSURLRequest *request = [NSURLRequest requestWithURL:baseURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:baseURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    NSURLSession *session = [[NSURLSession sharedSession] init];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          //Data
                                          
                                          NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

                                          NSDictionary *dictResponse = [[NSMutableDictionary alloc] init];
                                          
                                          dictResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
                                          
                                          dictResponse = [NSJSONSerialization JSONObjectWithData: [requestReply dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];

                                          if(dictResponse==nil)
                                          {
                                              if([delegate respondsToSelector:@selector(receivedError:fromWebservice:)])
                                                  [delegate receivedError:error.localizedFailureReason fromWebservice:self];
                                          }
                                          else if([delegate respondsToSelector:@selector(receivedResponse:fromWebservice:)])
                                          {
                                              [delegate receivedResponse:dictResponse fromWebservice:self];
                                          }
                                          else if ([delegate respondsToSelector:@selector(receivedResponse:)])
                                          {
                                              [delegate receivedResponse:dictResponse];
                                          }
                                      }];
    [dataTask resume];
    
    
}

-(void)getData : (NSString *)strGet
{
    
//    strGet = [NSString stringWithFormat:@"http://192.168.7.127/AvacabsWebAPI/api/ProfileAPI/%@",strGet];
   
    
    strGet = [strGet stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:strGet]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       // NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        //        NSLog(@"requestReply: %@", requestReply);
        
        if(!error)
        {
            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                        NSLog(@"requestReply: %@", requestReply);
            
//            // json s string for NSDictionary object
//            NSString *s = @"{\"MyAccountDetails\":[{\"FIRSTNAME\":\"Anuja\",\"Addres\":\"sadasdasdasds\",\"AlternatePhoneNumber\":9885455212,\"Permanant_Password\":\"fdfdsfsfs\",\"EmailID\":\"anuja.t@geewiz.in\",\"PhoneNumber\":9578450383,\"EmployeeID\":128,\"DestinationName\":\"Velachery\",\"EnrouteName\":\"Navalur\",\"Triptime\":\"08:00:00\",\"BookingType\":false}]}";
//            // comment above and uncomment below line, json s string for NSArray object
//            // NSString *s = @"[{\"ID\":{\"Content\":268,\"type\":\"text\"},\"ContractTemplateID\":{\"Content\":65,\"type\":\"text\"}}]";
//            
//            
//            
//            //    Note that JSONObjectWithData will return either an NSDictionary or an NSArray, depending whether your JSON string represents an a dictionary or an array.
//            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//            
//            
////         8   NSLog(@"str : %@",dict6);
//            
//            if (error) {
//                NSLog(@"Error parsing JSON: %@", error);
//            }
//            else
//            {
//                if ([jsonObject isKindOfClass:[NSString class]])
//                {
//                    NSLog(@"it is an array!");
//                    NSString *jsonArray = (NSString *)jsonObject;
//                    NSData *jsonData = [jsonArray dataUsingEncoding:NSASCIIStringEncoding];
//                    NSError *error;
//                    id jsonObjectss = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
//                    NSLog(@"jsonArray - %@",jsonObjectss);
//                }
//                else {
//                    NSLog(@"it is a dictionary");
//                    NSDictionary *jsonDictionary = (NSDictionary *)jsonObject;
//                    NSLog(@"jsonDictionary - %@",jsonDictionary);
//                }
//            }
//
          
            
            
            NSDictionary *dictResponse = [[NSMutableDictionary alloc] init];
            
            NSError *error1 = [[NSError alloc] init];
            
            dictResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &error1];
            
//            NSString *str = @"{\"Getmytrips\": [{\"tripdate\": \"7/24/2017\",\"tripstarttime\": \"10:10PM\",\"tripendtime\": \"12:00PM\",\"enroutename\": \"karapakam\",\"tripuserstatus\": \"cancelled\"}]}";
//            
//            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *dict123  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            
            
            if(dictResponse==nil)
            {
                if([delegate respondsToSelector:@selector(receivedError:fromWebservice:)])
                    [delegate receivedError:error1.description fromWebservice:self];
            }
            else if([delegate respondsToSelector:@selector(receivedResponse:fromWebservice:)])
            {
                [delegate receivedResponse:dictResponse fromWebservice:self];
            }
            else if ([delegate respondsToSelector:@selector(receivedResponse:)])
                [delegate receivedResponse:dictResponse];
        }
        else
        {
            if([delegate respondsToSelector:@selector(receivedError:fromWebservice:)])
                [delegate receivedError:error.localizedFailureReason fromWebservice:self];
        }
        
        
    }] resume];
}

- (void) postDataWithString:(NSString *)url withArguments:(NSString *)strPost
{
   
    strURL = url;
    
    NSData *postData = [strPost dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:url]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //[request setValue:strPost forHTTPHeaderField:@"data"];
    
    
    [request setHTTPBody:postData];
    
   
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if(!error)
        {
            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            //            NSLog(@"requestReply: %@", requestReply);
            
            NSDictionary *dictResponse = [[NSMutableDictionary alloc] init];
            
            NSError *error1 = [[NSError alloc] init];
            
            dictResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error1];
            
            
            
            
            
//            
//            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//            [dict setValue:@"1" forKey:@"DestinationID"];
//            [dict setValue:@"Velachery" forKey:@"DestinationName"];
//            
//            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
//            [dict1 setValue:@"2" forKey:@"DestinationID"];
//            [dict1 setValue:@"Tambaram" forKey:@"DestinationName"];
//            
//            
//            NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
//            [dict2 setValue:@"3" forKey:@"DestinationID"];
//            [dict2 setValue:@"Kelambakkam" forKey:@"DestinationName"];
//            
//            
//            NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
//            [dict3 setValue:@"4" forKey:@"DestinationID"];
//            [dict3 setValue:@"Guindy" forKey:@"DestinationName"];
//            
//            NSArray *arr = [[NSArray alloc]initWithObjects:dict,dict1,dict2,dict3, nil];
//            
//            
//            NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
//            [dict4 setValue:@"1" forKey:@"DestinationID"];
//            [dict4 setValue:@"4" forKey:@"EnrouteID"];
//            [dict4 setValue:@"Navalur" forKey:@"EnrouteName"];
//            
//            NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];
//            [dict5 setValue:@"2" forKey:@"DestinationID"];
//            [dict5 setValue:@"5" forKey:@"EnrouteID"];
//            [dict5 setValue:@"AGS" forKey:@"EnrouteName"];
//            
//            
//            NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]init];
//            [dict6 setValue:@"3" forKey:@"DestinationID"];
//            [dict6 setValue:@"6" forKey:@"EnrouteID"];
//            [dict6 setValue:@"sHOLLINGNALLUR" forKey:@"EnrouteName"];
//            
//            
//            NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]init];
//            [dict7 setValue:@"4" forKey:@"DestinationID"];
//            [dict7 setValue:@"7" forKey:@"EnrouteID"];
//            [dict7 setValue:@"karapakkam" forKey:@"EnrouteName"];
//            
//            NSMutableDictionary *dict8 = [[NSMutableDictionary alloc]init];
//            [dict8 setValue:@"2" forKey:@"DestinationID"];
//            [dict8 setValue:@"8" forKey:@"EnrouteID"];
//            [dict8 setValue:@"Thuraipakkam" forKey:@"EnrouteName"];
//            
//            
//            NSMutableDictionary *dict9 = [[NSMutableDictionary alloc]init];
//            [dict9 setValue:@"3" forKey:@"DestinationID"];
//            [dict9 setValue:@"9" forKey:@"EnrouteID"];
//            [dict9 setValue:@"SRP" forKey:@"EnrouteName"];
//            
//            
//            NSMutableDictionary *dict10 = [[NSMutableDictionary alloc]init];
//            [dict10 setValue:@"4" forKey:@"DestinationID"];
//            [dict10 setValue:@"10" forKey:@"EnrouteID"];
//            [dict10 setValue:@"Velacherry" forKey:@"EnrouteName"];
//            
//            NSMutableDictionary *dict11 = [[NSMutableDictionary alloc]init];
//            [dict11 setValue:@"4" forKey:@"DestinationID"];
//            [dict11 setValue:@"10" forKey:@"EnrouteID"];
//            [dict11 setValue:@"Velacherry" forKey:@"EnrouteName"];
//            
//            NSArray *arr1 = [[NSArray alloc]initWithObjects:dict4,dict5, nil];
//            NSArray *arr2 = [[NSArray alloc]initWithObjects:dict6,dict7, nil];
//            NSArray *arr3 = [[NSArray alloc]initWithObjects:dict8,dict9, nil];
//            NSArray *arr4 = [[NSArray alloc]initWithObjects:dict10,dict11, nil];
//            
//            
//            NSMutableDictionary *dict12 = [[NSMutableDictionary alloc]init];
//            [dict12 setValue:arr1 forKey:@"1"];
//            NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]init];
//            [dict13 setValue:arr2 forKey:@"2"];
//            NSMutableDictionary *dict14 = [[NSMutableDictionary alloc]init];
//            [dict14 setValue:arr3 forKey:@"3"];
//            NSMutableDictionary *dict15 = [[NSMutableDictionary alloc]init];
//            [dict15 setValue:arr4 forKey:@"4"];
//            
//            NSArray *arr5 = [[NSArray alloc]initWithObjects:dict12,dict13,dict14,dict15, nil];
//            
//            
//            NSMutableDictionary *dictTable = [[NSMutableDictionary alloc]init];
//            [dictTable setValue:arr forKey:@"Table"];
//            [dictTable setValue:arr5 forKey:@"Table1"];
//            

            
            
            
            if(dictResponse==nil)
            {
                if([delegate respondsToSelector:@selector(receivedError:fromWebservice:)])
                    [delegate receivedError:error1.description fromWebservice:self];
            }
            else if([delegate respondsToSelector:@selector(receivedResponse:fromWebservice:)])
            {
                [delegate receivedResponse:dictResponse fromWebservice:self];
            }
            else if ([delegate respondsToSelector:@selector(receivedResponse:)])
                [delegate receivedResponse:dictResponse];
        }
        else
        {
            if([delegate respondsToSelector:@selector(receivedError:fromWebservice:)])
                [delegate receivedError:error.localizedFailureReason fromWebservice:self];
        }
    }] resume];
    
    
    
    
    
}




@end

//
// {"GetTripdetails":
//     {"Table":
//         [
//         {"DestinationID":1,"DestinationName":"Velachery"},
//         {"DestinationID":2,"DestinationName":"Tambaram"},
//         {"DestinationID":3,"DestinationName":"Kelambakkam"},
//         {"DestinationID":4,"DestinationName":"Guindy"}
//          ],
//         "Table1":
//         [
//         {"DestinationID":1,"TripTime":"22:30:00"},
//         {"DestinationID":1,"TripTime":"17:30:00"}
//          ],
//         "Table2":
//         [
//         {"DestinationID":1,"EnrouteID":4,"EnrouteName":"Navalur"},
//         {"DestinationID":1,"EnrouteID":5,"EnrouteName":"AGS"},
//         {"DestinationID":1,"EnrouteID":6,"EnrouteName":"sHOLLINGNALLUR"},
//         {"DestinationID":1,"EnrouteID":7,"EnrouteName":"karapakkam"},
//         {"DestinationID":1,"EnrouteID":8,"EnrouteName":"Thuraipakkam"},
//         {"DestinationID":1,"EnrouteID":9,"EnrouteName":"SRP"},
//         {"DestinationID":1,"EnrouteID":10,"EnrouteName":"Velacherry"}
//          ]
//     }
// }
//


