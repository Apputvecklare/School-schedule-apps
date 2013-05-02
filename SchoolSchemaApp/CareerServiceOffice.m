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











@end
