//
//  iTetBoardView.m
//  iTetrinet
//
//  Created by Alex Heinz on 6/5/09.
//

#import "iTetBoardView.h"
#import "iTetBoard.h"
#import "iTetBlock.h"

@implementation iTetBoardView

- (id)initWithFrame:(NSRect)frame
{
	return [super initWithFrame:frame];
}

- (void)awakeFromNib
{	
	if (nicknameField != nil)
	{
		[nicknameField bind:@"value"
			     toObject:self
			  withKeyPath:@"owner.nickname"
				options:[NSDictionary dictionaryWithObject:@"No Player"
										forKey:NSNullPlaceholderBindingOption]];
	}
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)dirtyRect
{
	// Get the graphics context we are drawing to
	NSGraphicsContext* graphicsContext = [NSGraphicsContext currentContext];
	
	// Push the existing context onto the context stack
	[graphicsContext saveGraphicsState];
		
	// Get the background image from the theme
	NSImage* background = [[self theme] background];
	NSSize bgSize = [background size];
	
	NSSize viewSize = [self bounds].size;
	
	// Create an affine transform from the background's size to the view's size
	NSAffineTransform* scaleTransform = [NSAffineTransform transform];
	[scaleTransform scaleXBy:(viewSize.width / bgSize.width)
				   yBy:(viewSize.height / bgSize.height)];
	
	// Concatenate the transform to the graphics context
	[scaleTransform concat];
	
	// Draw the background
	[background drawAtPoint:NSZeroPoint
			   fromRect:NSZeroRect
			  operation:NSCompositeCopy
			   fraction:1.0];
	
	// If we have no board contents to draw, we are finished
	if (owner == nil)
	{
		// Pop graphics context before returning
		[graphicsContext restoreGraphicsState];
		return;
	}
	
	// Draw the board contents
	iTetBoard* board = [owner board];
	char cell;
	NSImage* cellImage;
	NSPoint drawPoint = NSZeroPoint;
	for (int row = 0; row < ITET_BOARD_HEIGHT; row++)
	{
		for (int col = 0; col < ITET_BOARD_WIDTH; col++)
		{
			// Get the cell type
			cell = [board cellAtRow:row
					     column:col];
			
			// If there is nothing to draw, skip to next iteration of loop
			if (cell == 0)
				continue;
			
			// Get the image for this cell
			cellImage = [theme imageForCellType:cell];
			
			// Move the point at which to draw the cell
			drawPoint.x = col * [theme cellSize].height;
			drawPoint.y = row * [theme cellSize].width;
			
			// Draw the cell
			[cellImage drawAtPoint:drawPoint
					  fromRect:NSZeroRect
					 operation:NSCompositeCopy
					  fraction:1.0];
		}
	}
	
	// Pop the graphics context
	[graphicsContext restoreGraphicsState];
}

#pragma mark -
#pragma mark Accessors

- (BOOL)isOpaque
{
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	return NO;
}

@end
