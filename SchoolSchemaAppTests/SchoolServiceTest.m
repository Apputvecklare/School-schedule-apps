//
//  SchoolServiceTest.m
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import "SchoolServiceTest.h"
#import "CareerServiceOffice.h"
#import "Student.h"
#import "SchemaOfCourse.h"
#import "SchoolPersonnel.h"
@implementation SchoolServiceTest

{
    CareerServiceOffice *service;
    Student *studentTom;
    SchemaOfCourse *schemaJavascriptDay1;
    SchoolPersonnel *dirPablo;
}

-(void) setUp
{
    
    service =[[CareerServiceOffice alloc]init];
    studentTom = [[Student alloc ]initWithStudentFirstName:@"Tom" lastName:@"tomssom" age:40 isAdmin:NO];
    schemaJavascriptDay1 = [[SchemaOfCourse alloc]initWithCreatingScheduleOfCourses:@"Javascript" task:@"Array" lesson_time:@"12:00 - 14:00" teacher:@"Tom Bery" local:4103 day:@"Theresady" date:@"90-05-2013" week:18 year:2013 klass:@"C3LJAVA03-13" lessonNumber : 1];
    dirPablo =  [[SchoolPersonnel alloc]initWithSchoolPersonnelFirstName:@"Pablo" lastName:@"Win" role:@"Director" isAdmin:YES];
    
}

-(void)tearDown
{
    service= nil;
    studentTom =nil;
    schemaJavascriptDay1 = nil;
}


-(void)testAddStudent{
    BOOL result = [service addStudent:studentTom ];
    
    STAssertTrue(result,@"Student is already exists!");
    
}

-(void)testPostSchema{
    
    BOOL result = [service postSchema:schemaJavascriptDay1 byAdmin:dirPablo onCompletion:^(NSData *getSchemaResponse) {
        
        NSString *dataencoding = [[NSString alloc] initWithData:getSchemaResponse  encoding:NSUTF8StringEncoding];
        NSLog(@"new schema posted.\n%@",dataencoding);
    }];
    
    
    STAssertTrue(result,@"postShcema,failed : Non-admin users have read and write access to all databases,sorry!");
    
}


-(void)testChangeInformationOfSchema{
    
    BOOL changed = [service changeInformationOfSchedule:schemaJavascriptDay1    courseName:@"JavaScript" date:@"01-07-2013" day:@"monday" klassNum:@"C3LKOMU03-13" lessonTime:@"12:00 - 15:00" local:4011 task:@"Blocks" teacher:@"Gustaf Nillson" week:28 year:2013 lessonNumber:1 byAdmin:dirPablo onCompletion:^(NSData *changeSchemaResponse) {
        
        NSString *dataencoding = [[NSString alloc] initWithData:changeSchemaResponse  encoding:NSUTF8StringEncoding];
        
        NSLog(@"information of a schema is changed  by Admin :\n%@",dataencoding);
        
    }];
    
    STAssertTrue(changed,@"Sorry, Only Admin can change the information of schema !");
    
}



-(void)testSendMessageToAllStudents
{
    
    NSString *messageToAll = @"Pablo bad mig att påminna om att på måndag klockan 10:00 är det en föreläsning om entreprenörskap. Detta är både för dig ";
    
    BOOL IsSendMessageToAll = [service sendMessageToAllStudents:messageToAll byAdmin:dirPablo onCompletion:^(NSData *getTextMessageResponse) {
        
        
        NSString *dataencoding = [[NSString alloc] initWithData:getTextMessageResponse  encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",dataencoding );
        
        
    }];
    
    STAssertTrue(IsSendMessageToAll,@"Send messagae to all: failed, \nNon-admin users have read and write access to all databases,sorry!");
    
}




@end
