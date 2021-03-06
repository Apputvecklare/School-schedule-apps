//
//  CareerServiceOffice.m
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import "CareerServiceOffice.h"
#import "Student.h"
#import "SchemaOfCourse.h"
#import "SchoolPersonnel.h"

@implementation CareerServiceOffice


{
    // Instance variables
    NSMutableSet *repositorySchema;
    NSMutableSet *repositoryTeacherStaff;
    NSMutableSet *repositorystudents;
    NSOperationQueue *queue;
    
}
#pragma mark - Init

- (id)init
{
    return [self initWithStudents:@[]];
}

-(id)initWithStudents:(NSArray *)studentsToAdd{
    
    
    self = [super init];
    
    if(self) {
        // Initialize all instance variables
        repositoryTeacherStaff = [[NSMutableSet alloc] init];
        repositorySchema = [[NSMutableSet alloc] init];
        repositorystudents = [[NSMutableSet alloc] init];
        
        // Add all students
        for(Student *student in studentsToAdd) {
            [self addStudent:student];
                
           
        }
        queue = [[NSOperationQueue alloc]init];
    }
    
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
            //////////////////    schema del    ///////////////////////////

#pragma mark - Add student/teacher/schema to local repository(s)

-(BOOL)addSchema:(SchemaOfCourse*)schema onCompletion:(responseAddSchema)resBlock

{
    
    
    if (![repositorySchema containsObject:schema]){
        
        [repositorySchema addObject:schema];
        resBlock(YES);
        return YES;
    }
    resBlock(NO);
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////
              ///// Add personnel staff to repositoryTeacherStaff ////////


-(BOOL) addTeacher:(SchoolPersonnel*) user onCompletion:(responseAddUser)resBlock
{
    if (![repositorySchema containsObject:user]){
        [repositoryTeacherStaff addObject:user];
        resBlock(YES);
        return YES;
    }
    resBlock(NO);
    return NO;
}

///////////////////////////////////////////////////////////////////////////////////////////


-(BOOL)addStudent : (Student*)student{
    
    if([repositorystudents containsObject:student.studentId])
    {
        return NO;
    }
    [repositorystudents addObject:student];
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////
                         ////// helper method ///////

#pragma mark - helper method

-(NSDictionary*) serializeStudentToJson:(id) object
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    [result setDictionary:[object asJsonValue]];
    
    
    return result;
}

//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
         ///////  talking to CouchDB using ReSTful HTTP methods.   /////////

#pragma mark - Get/Post student methods
-(void)getAllStudents:(GetResponse)getResponse
{
    
    NSURL *url = [NSURL URLWithString:@"http://studentschema.iriscouch.com/schema/_design/schema/_list/students/student"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
        
        NSArray *getAll= @[data];
        getResponse(getAll);
        
    }];
    
}

//////////////////////////////////////////////////////////////////////////////////////////
               ////////////  get student details  from DB  ////////////////

-(BOOL)getStudent:(Student *)student onCompletion:(GetStudentResponse)getResponse
{
    if ([repositorystudents containsObject:student]){
        
        NSMutableString *studentUrlName = [[NSMutableString alloc] init];
        [studentUrlName appendString:@"http://studentschema.iriscouch.com/schema/_design/schema/_list/students/student?key=%22"];
        NSString *studentFirstName = student.firstName;
        [studentUrlName appendString:studentFirstName];
        [studentUrlName appendString:@"%22"];
        
        NSOperationQueue *queue4 = [[NSOperationQueue alloc] init];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithString:studentUrlName]];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue4 completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
            
            getResponse(data);
            
        }];
        return YES;
    }else{
        return NO;
    }
    
}


///////////////////////////////////////////////////////////////////////////////////////////
                ///////////////  Post Student to DB  /////////////////

-(BOOL)postStudent : (Student*)student onCompletion:(PostResponse)postResponse
{
    BOOL getCheck = [self getStudent:student onCompletion:^(NSData *getStudentResponses) {
        
    }];
    if (!getCheck){
      
     NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    
     NSDictionary *dicFormatStudent = [self serializeStudentToJson:student];
    
     NSData *dataRequestBody = [NSJSONSerialization dataWithJSONObject:dicFormatStudent options:NSJSONWritingPrettyPrinted error:NULL];

     NSURL *url = [NSURL URLWithString:@"http://studentschema.iriscouch.com/schema/"];
    
     NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
     [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     [theRequest setHTTPMethod:@"POST"];
    
     [theRequest setHTTPBody:dataRequestBody];
    
     [NSURLConnection sendAsynchronousRequest:theRequest queue:queue1 completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
        
        
        postResponse(data);
        
        
     }];
      return YES;
  }else{
      return NO;
  }
}   


//////////////////////////////////////////////////////////////////////////////////////////
///////////////  a student can see his schedule for the day  ////////////////

//Url http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/days/daysoftheweek?key=["Friday",18,"C3LJAVA03-13"]



-(void)viewSchemaPerDay :(NSString*)day ofWeek:(int)week ofKlass:(NSString*)klassNum forStudent:(Student*)student onCompletion:(DaySchemaResponse)getDaySchemaResponses
{
    
    
    NSMutableString *dayUrlSchema = [[NSMutableString alloc] init];
    [dayUrlSchema appendString:@"http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/days/daysoftheweek?key=%5B%22"];
    NSString *dayName = day;
    [dayUrlSchema appendString:dayName];
    [dayUrlSchema appendString:@"%22"];
    [dayUrlSchema appendString:@"%2C"];
    
    [dayUrlSchema appendFormat:@"%d",week];
    
    [dayUrlSchema appendString:@"%2C"];
    [dayUrlSchema appendString:@"%22"];
    [dayUrlSchema appendFormat:@"%@",klassNum];
    [dayUrlSchema appendString:@"%22"];
    [dayUrlSchema appendString:@"%5D"];
    
    NSOperationQueue *queue5 = [[NSOperationQueue alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithString:dayUrlSchema]];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue5 completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
        
        getDaySchemaResponses(data);
        
    }];
}


/////////////////////////////////////////////////////////////////////////////////////////// 
               //////// a student can see his schedule for the week  ///////

//Url http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/weeks/week?key=[18,"C3LJAVA03-13"]

-(void)viewSchemaPerWeek :(int)week ofKlass:(NSString*)klassNum forStudent:(Student*)student onCompletion:(DaySchemaResponse)getDaySchemaResponses
{
    
    NSMutableString *weekUrlSchema = [[NSMutableString alloc] init];
    [weekUrlSchema appendString:@"http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/weeks/week?key=%5B"];
    
    [weekUrlSchema appendFormat:@"%d",week];
    [weekUrlSchema appendString:@"%2C"];
    [weekUrlSchema appendString:@"%22"];
    [weekUrlSchema appendFormat:@"%@",klassNum];
    [weekUrlSchema appendString:@"%22"];
    [weekUrlSchema appendString:@"%5D"];
    
    NSOperationQueue *queue6 = [[NSOperationQueue alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithString:weekUrlSchema]];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue6 completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
        
        getDaySchemaResponses(data);
        
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////
           //////student can see reading instructions for the day////////

//Url http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/tasks/taskonspecificdayoftheweek?key=["Friday", 21,"C3LJAVA03-13"]


-(void)viewTaskPerDay:(NSString*)day ofWeek:(int)week forStudent:(Student*)student ofKlass:klassNum onCompletion:(DayTaskResponse)getTaskResponses
{
    
    
    NSMutableString *taskDay = [[NSMutableString alloc] init];
    [taskDay appendString:@"http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/tasks/taskonspecificdayoftheweek?key=%5B%22"];
    NSString *dayName = day;
    [taskDay appendString:dayName];
    [taskDay appendString:@"%22"];
    [taskDay appendString:@"%2C"];
    [taskDay appendFormat:@"%d",week];
    [taskDay appendString:@"%2C"];
    [taskDay appendString:@"%22"];
    [taskDay appendString:klassNum];
    [taskDay appendString:@"%22"];
    [taskDay appendString:@"%5D"];
    
    NSOperationQueue *que7 = [[NSOperationQueue alloc] init];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithString:taskDay]];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:req queue:que7 completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
        
        getTaskResponses(data);
        
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////
           ////// Student can see reading instructions for the week ////////


//Url http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/tasks/taskofweek?key=[21,"C3LJAVA03-13"]


-(BOOL)viewTaskPerWeek :(int)week forStudent:(Student*)student ofKlass:(NSString*)klassNum onCompletion:(WeekTaskResponse)getWeekTaskResponses
{
    
    if ([repositorystudents containsObject:student]){
        
        NSMutableString *weeksTaskUrl = [[NSMutableString alloc] init];
        [weeksTaskUrl appendString:@"http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/tasks/taskofweek?key=%5B"];
        
        [weeksTaskUrl appendFormat:@"%d",week];
        [weeksTaskUrl appendString:@"%2C"];
        [weeksTaskUrl appendString:@"%22"];
        [weeksTaskUrl appendString:klassNum];
        [weeksTaskUrl appendString:@"%22"];
        [weeksTaskUrl appendString:@"%5D"];
        
        NSOperationQueue *queue8 = [[NSOperationQueue alloc] init];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithString:weeksTaskUrl]];
        
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:url];
        
        [req setHTTPMethod:@"GET"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [NSURLConnection sendAsynchronousRequest:req queue:queue8 completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
            
            NSArray *getTasks = @[data];
            getWeekTaskResponses(getTasks);
            
        }];
        return YES;
        
    }else{
        
        return NO;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////
                    /////  Post schema by admin only  /////////
#pragma mark - Get/Post/Update schema methods

-(BOOL)postSchema :(SchemaOfCourse*)schema byAdmin:(id)other onCompletion:(postSchemaResponse)getSchemaResponse
{
    
    if ([other isAdmin]) {
        
        NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
        
        
        NSDictionary *dicFormat = [schema asJsonValue];
        
        NSData *dataRequestBody = [NSJSONSerialization dataWithJSONObject:dicFormat options:NSJSONWritingPrettyPrinted error:NULL];
        
        NSURL *url = [NSURL URLWithString:@"http://studentschema.iriscouch.com/schema/"];
        
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        
        [theRequest addValue: @"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPMethod:@"POST"];
        
        [theRequest setHTTPBody:dataRequestBody];
        
        [NSURLConnection sendAsynchronousRequest:theRequest queue:queue1 completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
            
            
            getSchemaResponse(data);
            
            
        }];
        
        return YES;
        
    }else{
        
        return NO;
        
    }
        
}

///////////////////////////////////////////////////////////////////////////////////////////
                      /////  change schema by admin only  /////////


-(BOOL)changeInformationOfSchedule :(SchemaOfCourse*)schema courseName:(NSString*)courseName date:(NSString*)date day:(NSString*)day klassNum:klassNum lessonTime:(NSString*)lessonTime local:( NSUInteger)local  task:(NSString*)task teacher :(NSString*)teacher week: (NSUInteger)week year:(NSUInteger)year lessonNumber:(int)lessonNumber byAdmin:(id)other  onCompletion:(postchangeSchemaResponse)changeSchemaResponse
{
    
    // Url  http://studentschema.iriscouch.com/schema/_design/app/_list/schedulelistby/getscheduleby?key=["C3LENG01-13","Theresady",2]
    
    if ([other isAdmin]) {
        
        NSOperationQueue *que1 = [[NSOperationQueue alloc]init];
        
        NSMutableString *changeSchema = [[NSMutableString alloc] init];
        [changeSchema appendString:@"http://studentschema.iriscouch.com/schema/_design/app/_list/schedulelistby/getscheduleby?key=%5B%22"];
        
        [changeSchema appendString:schema.klassNum];
        [changeSchema appendString:@"%22"];
        [changeSchema appendString:@"%2C"];
        [changeSchema appendString:@"%22"];
        [changeSchema appendString:schema.day];
        [changeSchema appendString:@"%22"];
        [changeSchema appendString:@"%2C"];
        [changeSchema appendFormat:@"%lu",schema.week];
        [changeSchema appendString:@"%5D"];
   
     //  Get method
        
        NSURL *url1 = [NSURL URLWithString:changeSchema];
        
        NSMutableURLRequest *req= [NSMutableURLRequest requestWithURL:url1];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [req setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:req queue:que1 completionHandler:^(NSURLResponse *responseBody, NSData *data1, NSError *error) {
            
            id responseEncoding = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:&error];
            
     // Url   http://studentschema.iriscouch.com/schema/ee9f3924a9a305a351ac039d98007959?rev=1-680153c2c88bdce835d621d556c307b7
            
            
            NSString * docId =[[responseEncoding objectAtIndex:0 ]valueForKeyPath:@"_id"];
            NSString * revId =[[responseEncoding objectAtIndex:0 ]valueForKeyPath:@"_rev"];
 
            NSMutableString  *urlString =[[NSMutableString alloc]init];
            [urlString appendString:@"http://studentschema.iriscouch.com/schema/"];
            [urlString appendString:docId];
            [urlString appendString:@"?rev="];
            [urlString appendString:revId];
            
            NSURL *url2 = [NSURL URLWithString:urlString];
            NSOperationQueue *que2 = [[NSOperationQueue alloc]init];
            
            NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
            
            [req2 setValue:@"applicaion/json" forHTTPHeaderField:@"Accept"];
            [req2  setHTTPMethod:@"PUT"];
            
            NSMutableDictionary *AsJson = [[NSMutableDictionary alloc] init];
            AsJson[@"schemaId"] = [schema schemaId];
            AsJson[@"week"] = @(week);
            AsJson[@"date"] = date;
            AsJson[@"local"] = [NSNumber numberWithInt:local];
            AsJson[@"day"] = @"Friday";
            AsJson[@"year"] = @(year);
            AsJson[@"teacher"] = teacher;
            AsJson[@"task"] = schema.task;
            AsJson[@"lesson_time"] =lessonTime;
            AsJson[@"course_name"] = courseName;
            AsJson[@"klassNum"] = klassNum;
            AsJson[@"type"] = @"course";
            AsJson[@"lesson_Number"] = @(lessonNumber);
            
            NSData *requestBody = [NSJSONSerialization dataWithJSONObject:AsJson options:NSJSONWritingPrettyPrinted error:NULL];
            [req2 setHTTPBody:requestBody];
            
            [NSURLConnection sendAsynchronousRequest:req2 queue:que2 completionHandler:^(NSURLResponse *respons, NSData *data, NSError *error) {
                
                
                changeSchemaResponse(data);
            }];
            
        }];
        
        return YES;
        
    }else{
        
        return NO;

    }
    
}



///////////////////////////////////////////////////////////////////////////////////////////
          ///// Add message to a particular student by admin only /////////


//Url http://studentschema.iriscouch.com/schema/_design/schema/_list/students/messagetostudent?key="zoe"

-(BOOL) sendTextMessage:(NSString*)message toStudent:(Student*)student byAdmin:(id)other onCompletion:(postMessageResponse)getMessageResponse

{
    
    if ([other isAdmin]) {
        
        NSOperationQueue *queue1 = [[NSOperationQueue alloc]init];
        
        NSMutableString *urlGetSudent = [[NSMutableString alloc] init];
        [urlGetSudent  appendString:@"http://studentschema.iriscouch.com/schema/_design/schema/_list/students/messagetostudent?key=%22"];
        
        [urlGetSudent appendString:student.firstName];
        [urlGetSudent appendString:@"%22"];
        
        NSURL *url = [NSURL URLWithString:urlGetSudent];
        
        NSMutableURLRequest *newReq= [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:35.0];
        [newReq setHTTPMethod:@"GET"];
        [newReq setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [NSURLConnection sendAsynchronousRequest:newReq queue:queue1 completionHandler:^(NSURLResponse *responseBody, NSData *NewData, NSError *error) {
            
            
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:NewData options:0 error:&error];
            NSString * docId =[[jsonResponse objectAtIndex:0 ] valueForKeyPath:@"_id"];
            NSString * revId =[[jsonResponse objectAtIndex:0 ] valueForKeyPath:@"_rev"];
            
            NSMutableString  *urlPostChanges =[[NSMutableString alloc]init];
            [urlPostChanges appendString:@"http://studentschema.iriscouch.com/schema/"];
            [urlPostChanges appendString:docId];
            [urlPostChanges appendString:@"?rev="];
            [urlPostChanges appendString:revId];
            
    // Put method
            
            NSURL *url2 = [NSURL URLWithString:urlPostChanges];
            NSOperationQueue *que2 = [[NSOperationQueue alloc]init];
            
            NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
            
            [req2 setValue:@"applicaion/json" forHTTPHeaderField:@"Accept"];
            [req2  setHTTPMethod:@"PUT"];
            
            NSMutableDictionary *AsJson = [[NSMutableDictionary alloc] init];
            
            AsJson[@"studentId"] = student.studentId;
            AsJson[@"firstName"] = student.firstName;
            AsJson[@"lastName"] = student.lastName;
            AsJson[@"age"] = @(student.age);
            AsJson[@"type"] = @"student";
            AsJson[@"isAdmin"] = @(student.admin);
            AsJson[@"message"] = message;
            
            
            NSData *requestBody = [NSJSONSerialization dataWithJSONObject:AsJson options:NSJSONWritingPrettyPrinted error:NULL];
            [req2 setHTTPBody:requestBody];
            
            [NSURLConnection sendAsynchronousRequest:req2 queue:que2 completionHandler:^(NSURLResponse *respons, NSData *data, NSError *error) {
                
                NSString *str = @"Message sended to a particular student successfully";
                getMessageResponse(str);
                
            }];
            
        }];
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}



///////////////////////////////////////////////////////////////////////////////////////////
              /////// Send message to all students  by Admin //////////


-(BOOL) sendMessageToAllStudents:(NSString*)textMessage  byAdmin:(id)other  onCompletion:(postTextMessageResponse)getTextMessageResponse
{
    
// Url http://studentschema.iriscouch.com/schema/_design/schema/_list/students/messagetostudent
    
    if ([other isAdmin]) {
        
        NSOperationQueue *que1 = [[NSOperationQueue alloc]init];
        NSURL *url = [NSURL URLWithString:@"http://studentschema.iriscouch.com/schema/_design/schema/_list/students/messagetostudent"];
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [req setHTTPMethod:@"GET"];
        [NSURLConnection sendAsynchronousRequest:req queue:que1 completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
            
            id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            for (int i=0; i < [response count];i++){
                NSString * docId =[[response objectAtIndex:i ] valueForKeyPath:@"_id"];
                NSString * revId =[[response objectAtIndex:i ]valueForKeyPath:@"_rev"];
                
                NSMutableString  *urlPostChanges =[[NSMutableString alloc]init];
                [urlPostChanges appendString:@"http://studentschema.iriscouch.com/schema/"];
                [urlPostChanges appendString:docId];
                [urlPostChanges appendString:@"?rev="];
                [urlPostChanges appendString:revId];
        // Put method         
                NSURL *url2 = [NSURL URLWithString:urlPostChanges];
                NSOperationQueue *que2 = [[NSOperationQueue alloc]init];
                
                NSMutableURLRequest *req2 = [NSMutableURLRequest requestWithURL:url2];
                
                [req2 setValue:@"applicaion/json" forHTTPHeaderField:@"Accept"];
                [req2  setHTTPMethod:@"PUT"];
                
                NSMutableDictionary *AsJsonStudent = [[NSMutableDictionary alloc] init];
                
                AsJsonStudent[@"studentId"] = [[response objectAtIndex:i] valueForKeyPath:@"studentId"];
                AsJsonStudent[@"firstName"] =[[response objectAtIndex:i] valueForKeyPath:@"firstName"];
                AsJsonStudent[@"lastName"] = [[response objectAtIndex:i] valueForKeyPath:@"lastName"];
                AsJsonStudent[@"age"] = [[response objectAtIndex:i] valueForKeyPath:@"age"];
                AsJsonStudent[@"type"] = @"student";
                AsJsonStudent[@"isAdmin"] =[[response objectAtIndex:i] valueForKeyPath:@"isAdmin"];
                AsJsonStudent[@"message"] = textMessage;
                
                
                NSData *requestBody = [NSJSONSerialization dataWithJSONObject:AsJsonStudent options:NSJSONWritingPrettyPrinted error:NULL];
                [req2 setHTTPBody:requestBody];
                
                [NSURLConnection sendAsynchronousRequest:req2 queue:que2 completionHandler:^(NSURLResponse *respons, NSData *data, NSError *error) {
                    getTextMessageResponse(data);
                    
                }];
                
            }
            
        }];
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}


@end
