//
//  main.m
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "CareerServiceOffice.h"
#import "SchemaOfCourse.h"
#import "SchoolPersonnel.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        
        CareerServiceOffice *service = [[CareerServiceOffice alloc] init];
        Student *zoe = [[Student alloc]initWithStudentFirstName:@"zoe" lastName:@"Eriksson" age:27 isAdmin:NO];
        
        SchoolPersonnel *Pablo = [[SchoolPersonnel alloc]initWithSchoolPersonnelFirstName:@"Pablo" lastName:@"Win" role:@"Director" isAdmin:YES];
        
///////////////////////////////////////////////////////////////////////////////////////////
        // Student //
        
        [service addStudent:zoe ];
        
        
        BOOL checkpost= [service postStudent:zoe onCompletion:^(NSData *postResponses) {
            NSString *dataencoding = [[NSString alloc] initWithData:postResponses  encoding:NSUTF8StringEncoding];
            NSLog(@"Student is added to database :%@\n",dataencoding);
        }];
        if (!checkpost){
            NSLog(@"failed to post,this student is already exists in Db ");
        }else{
            NSLog(@"Student is added to database!");
        }
        
        
        
    
        [service addTeacher:Pablo onCompletion:^(BOOL resBlock) {
            if (resBlock){
                NSLog(@"Success,new SchoolPersonnel added!\n ");
            }else{
                NSLog(@"Schema is already exists!");
            }
        }];
        
///////////////////////////////////////////////////////////////////////////////////////////

        SchemaOfCourse *schemaKommunikationDay1 =  [[SchemaOfCourse alloc] initWithCreatingScheduleOfCourses:@"Kommunikation" task:@"nätvärk-1" lesson_time:@"10:00 - 12:00" teacher:@"Gustaf Nillson" local:4108 day:@"Wensday" date:@"16-06-2013" week:4 year:2013 klass:@"C3LKOMU03-13" lessonNumber : 1];
        
        
        [service addSchema:schemaKommunikationDay1 onCompletion:^(BOOL resBlock) {
            
            if (resBlock){
                NSLog(@"Success,scheam has been added!\n ");
            }else{
                
                NSLog(@"Schema is already exists!");
            }
            
        }];
        
        BOOL postSchema = [service postSchema :schemaKommunikationDay1 byAdmin:Pablo onCompletion:^(NSData *postResponses) {
            
            NSString *dataencoding = [[NSString alloc] initWithData:postResponses  encoding:NSUTF8StringEncoding];
            NSLog(@"new schema posted:\n%@",dataencoding);
        }];
        
        
        if(!postSchema){
            NSLog(@"postShcema,failed: Non-admin users have read and write access to all databases,sorry!\n");
        }

        
//////////////////////////////////////////////////////////////////////////////////////////
                      
        
        [service viewSchemaPerDay:@"Wensday" ofWeek:4  ofKlass:@"C3LKOMU03-13" forStudent:zoe onCompletion:^(NSData *getDaySchemaResponses) {
            NSLog(@"%@ %@ is student in C3L school and his schedule : is",zoe.firstName,zoe.lastName);
            NSString *dataEncoding = [[NSString alloc] initWithData:getDaySchemaResponses encoding:NSUTF8StringEncoding];
            NSLog(@"%@\n",dataEncoding);
        }];
        
        
        
//////////////////////////////////////////////////////////////////////////////////////////
        
        
        [service viewTaskPerWeek:4 forStudent:zoe ofKlass:@"C3LKOMU03-13" onCompletion:^(NSArray *getWeeksTaskResponses) {
            
            NSLog(@"Daily task summary on the given weekday:");
            
            for (id task in getWeeksTaskResponses){
                
                id response = [NSJSONSerialization JSONObjectWithData:task options:0 error:NULL];
                for (int i=0; i < [response count];i++){
                    NSString * day =[[response objectAtIndex:i ] valueForKeyPath:@"day"];
                    NSString * date =[[response objectAtIndex:i ] valueForKeyPath:@"date"];
                    NSString *task =[[response objectAtIndex:i ] valueForKeyPath:@"task"];
                    NSString *klassNum =[[response objectAtIndex:i ] valueForKeyPath:@"klassNum"];
                    NSLog(@"Klass: %@",klassNum);
                    NSString *lesson_time =[[response objectAtIndex:i ] valueForKeyPath:@"lesson_time"];
                    NSLog(@"Task %d about: %@\n on %@  %@ at %@",i+1,task,day,date,lesson_time);
                }
                
            }
            
        }];
    

        
    BOOL changed = [service changeInformationOfSchedule:schemaKommunikationDay1 courseName:@"Kommunikation" date:@"01-07-2013" day:@"monday" klassNum:@"C3LKOMU03-13" lessonTime:@"12:00 - 15:00" local:4011 task:@"Internet" teacher:@"Gustaf Nillson" week:1 year:2013 lessonNumber:1 byAdmin:Pablo onCompletion:^(NSData *changeSchemaResponse) {
        
        NSString *dataencoding = [[NSString alloc] initWithData:changeSchemaResponse  encoding:NSUTF8StringEncoding];
                        NSLog(@"information of a schema is changed  by Admin :\n%@",dataencoding);
        }];
        
        if(!changed){
       
            NSLog(@"Non-admin users have read and write access to all databases!\nSorry, you can not change informaion in a schema!");
        }
    
        

        
        NSString *messageToAll = @"Pablo bad mig att påminna om att på måndag klockan 10:00 är det en föreläsning om entreprenörskap. Detta är både för dig ";
        
        BOOL IsSendMessageToAll = [service sendMessageToAllStudents:messageToAll byAdmin:Pablo onCompletion:^(NSData *getTextMessageResponse) {
                        
            NSString *dataencoding = [[NSString alloc] initWithData:getTextMessageResponse  encoding:NSUTF8StringEncoding];
                    
            NSLog(@"%@",dataencoding );
                
                  
        }];
        if (!IsSendMessageToAll){
              NSLog(@"Send messagae to all: failed, \nNon-admin users have read and write access to all databases,sorry!");
        }else{
              NSLog(@"message was sent successfully to all students");
        }
        
        
        NSString *messageToOne = @" Hej, vi kan ta det på måndag då jag är i skolan.  ";
        
        BOOL IsMessageSended = [service sendTextMessage:messageToOne toStudent:zoe byAdmin:Pablo onCompletion:^(NSString *getMessageResponse) {
                            NSLog(@"%@",getMessageResponse);
        }];
        
        if (!IsMessageSended){
                NSLog(@"Send messagae to Student: failed, \nNon-admin users have read and write access to all databases,sorry!");
        }
        
        
        [[NSRunLoop currentRunLoop] run];
        

        
    }
    return 0;
}

