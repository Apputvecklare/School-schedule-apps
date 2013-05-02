//
//  CareerServiceOffice.h
//  SchoolSchemaApp
//
//  Created by Ashraf Jibrael on 5/2/13.
//  Copyright (c) 2013 Ashraf Jibrael. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student;
@class SchemaOfCourse;
@class SchoolPersonnel;

@interface CareerServiceOffice : NSObject

typedef void (^GetResponse)(NSArray* getResponses);
typedef void (^PostResponse)(NSData * postResponses);
typedef void (^GetStudentResponse)(NSData * getStudentResponses);
typedef void (^DaySchemaResponse)(NSData * getDaySchemaResponses);
typedef void (^WeekSchemaResponse)(NSData * getWeekSchemaResponses);
typedef void (^DayTaskResponse)(NSData * getTaskResponses);
typedef void (^WeekTaskResponse)(NSArray * getWeelsTaskResponses);
typedef void (^postSchemaResponse)(NSData * getSchemaResponse);
typedef void (^postchangeSchemaResponse)(NSData  *changeSchemaResponse);
typedef void (^postMessageResponse)(NSString * getMessageResponse);
typedef void (^postTextMessageResponse)(NSData * getTextMessageResponse);
typedef void (^responseAddSchema)(BOOL resBlock);
typedef void (^responseAddUser)(BOOL resBlock);
typedef void (^responseAddStudent)(BOOL resBlock);

-(id) initWithStudents:(NSArray*) studentsToAdd;


-(BOOL)addStudent : (Student*)student onCompletion:(responseAddStudent)resBlock;



-(BOOL)removeStudent :(Student*)student;


//schema methods

-(BOOL)addSchema:(SchemaOfCourse*) schema onCompletion:(responseAddSchema)resBlock;


// staff school
-(BOOL) addUser:(SchoolPersonnel*) user onCompletion:(responseAddUser)resBlock;


-(BOOL)postSchema :(SchemaOfCourse*)schema byAdmin:(id)other onCompletion:(postSchemaResponse)getSchemaResponse;


//http methods:

-(void)getAllStudents:(GetResponse)response;
-(void)postStudent : (Student*)student onCompletion:(PostResponse)postResponse;
-(void)getStudent : (Student*)student onCompletion:(GetStudentResponse)getResponse;
-(void)viewSchemaPerDay :(NSString*)day ofWeek:(int)week ofKlass:(NSString*)klassNum forStudent:(Student*)student onCompletion:(DaySchemaResponse)getDaySchemaResponses;
-(void)viewSchemaPerWeek :(int)week ofKlass:(NSString*)klassNum forStudent:(Student*)student onCompletion:(WeekSchemaResponse)getWeekSchemaResponses;
-(void)viewTaskPerDay :(NSString*)day ofWeek:(int)week forStudent:(Student*)student ofKlass:(NSString*)klassNum onCompletion:(DayTaskResponse)getTaskResponses;
-(BOOL)viewTaskPerWeek :(int)week forStudent:(Student*)student ofKlass:(NSString*)klassNum onCompletion:(WeekTaskResponse)getWeekTaskResponses;



-(BOOL)changeInformationOfSchedule :(SchemaOfCourse*)schema courseName:(NSString*)courseName date:(NSString*)date day:(NSString*)day klassNum:klassNum lessonTime:(NSString*)lessonTime local:( NSUInteger)local  task:(NSString*)task teacher :(NSString*)teacher week: (NSUInteger)week year:(NSUInteger)year lessonNumber:(int)lessonNumber byAdmin:(id)other  onCompletion:(postchangeSchemaResponse)changeSchemaResponse;


-(BOOL) sendTextMessage:(NSString*)message toStudent:(Student*)student byAdmin:(id)other onCompletion:(postMessageResponse)getMessageResponse;

-(BOOL)sendMessageToAllStudents:(NSString*)textMessage  byAdmin:(id) Admin  onCompletion:(postTextMessageResponse)getTextMessageResponse;








@end
