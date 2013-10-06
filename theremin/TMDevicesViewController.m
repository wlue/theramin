//
//  TMDevicesViewController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMDevicesViewController.h"
#import "TMBluetoothController.h"
#import "TMDevicesAPIController.h"
#import "TMPeripheral.h"

#pragma mark - Private Methods

@interface TMDevicesViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    NSFetchedResultsControllerDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)doneButtonPressed:(id)sender;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


#pragma mark - Implementation

@implementation TMDevicesViewController

#pragma mark - Initialization

- (id)init
{
    if (!(self = [super init])) {
        return nil;
    }

    self.title = @"Nearby Devices";

    NSFetchRequest *request = [TMPeripheral createFetchRequest];
    request.sortDescriptors = @[
        [[NSSortDescriptor alloc] initWithKey:RXTypedKeyPath(TMPeripheral, uuid) ascending:YES]
    ];

    NSManagedObjectContext *context = [[TMDevicesAPIController sharedInstance] managedObjectContext];
    NSFetchedResultsController *fetchedResultsController =
        [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                            managedObjectContext:context
                                              sectionNameKeyPath:nil
                                                       cacheName:nil];

    fetchedResultsController.delegate = self;

    self.fetchedResultsController = fetchedResultsController;
    [self.fetchedResultsController performFetch:NULL];

    return self;
}

#pragma mark - UIViewController

- (void)loadView
{
    [super loadMainView];

    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(doneButtonPressed:)];

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;

    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([[TMBluetoothController sharedInstance] mode] == TMBluetoothModeCentral) {
        [[TMBluetoothController sharedInstance] startScanning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TMPeripheral *peripheral = (TMPeripheral *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    if (!peripheral) {
        return;
    }

    [self.delegate devicesViewController:self didSelectPeripheral:peripheral];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController sections][section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"UITableViewCell"];
    }

    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }

        case NSFetchedResultsChangeDelete: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }

        case NSFetchedResultsChangeUpdate: {
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
        }

        case NSFetchedResultsChangeMove: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Public Methods

#pragma mark - Private Methods

- (void)doneButtonPressed:(id)sender
{
    [self.delegate devicesViewControllerDidClose:self];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    TMPeripheral *peripheral = (TMPeripheral *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = peripheral.name ?: @"Unknown Device";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", peripheral.rssi];
}

@end
