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
            [self addStudent:student onCompletion:^(BOOL resBlock) {
                
            }];
        }
        queue = [[NSOperationQueue alloc]init];
    }
    
    return self;
    
}


///////////////////////////////////////////////////////////////////////////////////////////
//////////////////    schema del    ///////////////////////////

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


-(BOOL)addStudent : (Student*)student onCompletion:(responseAddStudent)resBlock{
    
    if([repositorystudents containsObject:student.studentId])
    {
        resBlock(NO);
        return NO;
    }
    [repositorystudents addObject:student];
    resBlock(YES);
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////


//helper method

-(NSDictionary*) serializeStudentToJson:(id) object
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    [result setDictionary:[object asJsonValue]];
    
    
    return result;
}

//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
         ///////  talking to CouchDB using ReSTful HTTP methods.   /////////


-(void)getAllStudents:(GetResponse)getResponse
{
    
    NSURL *url = [NSURL URLWithString:@"http://studentschema.iriscouch.com/schema/_design/schema/_list/students/student"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *responseBody, NSData *data, NSError *error) {
        
        NSArray *getAll= @[data];
        getResponse(getAll);
        
    }];
    
}

//////////////////////////////////////////////////////////////////////////////////////////
               ////////////  get student details  from DB  ////////////////

-(void)getStudent:(Student *)student onCompletion:(GetStudentResponse)getResponse
{
    
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
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////
                ///////////////  Post Student to DB  /////////////////

-(void)postStudent : (Student*)student onCompletion:(PostResponse)postResponse
{
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
    
}   


//////////////////////////////////////////////////////////////////////////////////////////
///////////////  a student can see his schedule for the day  ////////////////

//http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/days/daysoftheweek?key=["Friday",18,"C3LJAVA03-13"]



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

//http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/weeks/week?key=[18,"C3LJAVA03-13"]

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

//http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/tasks/taskonspecificdayoftheweek?key=["Friday", 21,"C3LJAVA03-13"]


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
        
        //  NSArray *getAll= @[data];
        getTaskResponses(data);
        
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////
           ////// Student can see reading instructions for the week ////////


//http://studentschema.iriscouch.com/schema/_design/apputvecklareschema/_list/tasks/taskofweek?key=[21,"C3LJAVA03-13"]


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










@end
