//
//  MSParser.h
//  numeriVerdi
//
//  Created by Moises Swiczar on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MSBlancas : NSObject {

	
}

+(BOOL) buscar:(NSMutableDictionary*)thedictparameter thearray:(NSMutableArray*)thearray pagina:(NSUInteger)pagina;
+(BOOL) buscarTelefonos:(NSMutableDictionary*)thedictparameter thearray:(NSMutableArray*)thearray;



//http://paginasblancas.com.ar/busqueda-nombre/argentina/swic-pagina-2



@end
