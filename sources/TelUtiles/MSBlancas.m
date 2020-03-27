//
//  MSParser.m
//  numeriVerdi
//
//  Created by Moises Swiczar on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MSBlancas.h"


@implementation MSBlancas



+(char *) findGetAnunciantesStart:(char *) strchar
{
//	NSLog(@"%s",strchar);

	char* salida = strstr(strchar,"var anunciantesSeleccionados = '");
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida+strlen("var anunciantesSeleccionados = '");
		
	}
}

+(char*) findGetAnunciantesEnd :(char *) strchar
{
	char* salida = strstr(strchar,"';");
	
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida;
	}
	
	
}

+(char *) findGetAbonadosStart:(char *) strchar
{
	char* salida = strstr(strchar,"var abonadosSeleccionados = '");
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida+strlen("var abonadosSeleccionados = '");
		
	}
}

+(char*) findGetAbonadosEnd :(char *) strchar
{
	char* salida = strstr(strchar,"';");
	
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida;
	}
	
	
}






+(char*) findStartRow :(char *) strchar
{
	char* salida = strstr(strchar,"<H2 class=\"alta\">");
	
	
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida+strlen("<H2 class=\"alta\">");
		
	}
}

+(char*) findEndRow :(char *) strchar
{
	char* salida = strstr(strchar,"</H2>");
	
	
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida;
	}
	
	
}



+(char*) findStartTel :(char *) strchar
{
	char* salida = strstr(strchar,"<H3><STRONG>");
	
	
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida+strlen("<H3><STRONG>");
		
	}
}



+(char*) findEndTel :(char *) strchar
{
	char* salida = strstr(strchar,"</STRONG></H3>");
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida;
	}
}




+(char*) findStartDireccion :(char *) strchar
{
	char* salida = strstr(strchar,"</H3>");
	
	
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida+strlen("</H3>");
		
	}
}




+(char*) findEndDireccion :(char *) strchar
{
	char* salida = strstr(strchar,"</td>");
	if  (salida ==NULL)
	{
		return NULL;
	}
	else
	{
		return salida;
	}
}




+(NSUInteger) complete:(NSString*) thestr  thearray:(NSMutableArray*)thearray
{

	
	NSString * stringNombre    =@"";
	NSString * stringTel       =@"";
	NSString * stringDireccion =@"";
	
	NSUInteger salida=0;
	char* strst =(char*)[thestr UTF8String];
	
	
	char* working = [MSBlancas findStartRow:strst];
	char* end;
	if (working ==NULL)
	{
		return salida;
	}
	while (working!=NULL) 
	{
		end = [MSBlancas findEndRow:working];
		if (end !=NULL)
		{
			end[0] =0x00;
			stringNombre =[NSString stringWithUTF8String:working]; 
			end[0] =' ';

			working = [MSBlancas findStartTel:end];
			if (working !=NULL)
			{
				end = [MSBlancas findEndTel:working];
				if (end !=NULL)
				{
					end[0] =0x00;
					stringTel =[NSString stringWithUTF8String:working]; 
					end[0] =' ';
				}					
			}
			working = [MSBlancas findStartDireccion: end];
			
			if (working !=NULL)
			{
				end = [MSBlancas findEndDireccion:working];
				if (end !=NULL)
				{
					end[0] =0x00;
					
					
					stringDireccion = [NSString stringWithUTF8String:working]; 
					end[0] =' ';
					NSMutableDictionary * thedict = [[NSMutableDictionary alloc]init];
					[thedict setObject:stringNombre forKey:@"nombre"];
					[thedict setObject:stringTel forKey:@"tel"];
					
					NSArray* chunks = [stringDireccion componentsSeparatedByString: @"-"];
					
					
					if ([chunks count]==3)
					{
						stringDireccion = [NSString stringWithFormat:@"%@\n%@ %@",
										   [[chunks objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
										   [[chunks objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
										   [[chunks objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
						
					}
					else 
					{
						stringDireccion = [NSString stringWithFormat:@"%@\n%@",
										   [[chunks objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]],
										   [[chunks objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
						
					}

					
				
					
					[thedict setObject:stringDireccion forKey:@"direccion"];
					
					[thearray addObject:thedict];
					[thedict release];
					
					
					salida++;
				}					
				
			}				
			working = [MSBlancas findStartRow:end];
		}
	}
	return salida;
	
}



//011-4778-0544

+(BOOL) buscarTelefonos:(NSMutableDictionary*)thedictparameter thearray:(NSMutableArray*)thearray
{
	BOOL salida =NO;
	NSString *mystringURL;

	mystringURL = [NSString stringWithFormat:@"http://www.paginasblancas.com.ar/busqueda-telefono/argentina/%@",[thedictparameter objectForKey:@"telefono"]];
	
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setTimeoutInterval:15]; 
	[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
	[request setURL:[NSURL URLWithString:mystringURL]];
	[request setHTTPMethod:@"GET"];
	
	NSURLResponse *response;
	NSError *error=nil;
	NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if ( (d) && (error.code == 0))
	{
		NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSISOLatin2StringEncoding];
		if ([MSBlancas complete:myResponse thearray:thearray] >0)
		{
			salida =YES;
		}
		else
		{
			salida =NO;
		}
	}
	return salida;

}




+(BOOL) buscar:(NSMutableDictionary*)thedictparameter thearray:(NSMutableArray*)thearray pagina:(NSUInteger)pagina
{
	
	
	
	NSMutableString *auxspace = [[NSMutableString alloc] initWithString:[thedictparameter objectForKey:@"str"]];
	
	[auxspace replaceOccurrencesOfString:@" " withString:@"-" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [auxspace  length])];

	[thedictparameter setObject:auxspace forKey:@"str"];
	[auxspace release];
	
	
	
	BOOL salida =NO;
	NSString *mystringURL;
	NSInteger id_provincia=[[thedictparameter objectForKey:@"id_provincia"] intValue];
	if(pagina==1)
	{
		if(id_provincia==0)
		{
			mystringURL = [NSString stringWithFormat:@"http://paginasblancas.com.ar/busqueda-nombre/argentina/%@",[thedictparameter objectForKey:@"str"]];
		}
		else 
		{
			mystringURL = [NSString stringWithFormat:@"http://paginasblancas.com.ar/busqueda-nombre/argentina/%@/%@",[thedictparameter objectForKey:@"str_prov"],[thedictparameter objectForKey:@"str"]];

		}
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setTimeoutInterval:15]; 
		[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
		[request setURL:[NSURL URLWithString:mystringURL]];
		[request setHTTPMethod:@"GET"];
		
		
		NSURLResponse *response;
		NSError *error=nil;
		NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		if ( (d) && (error.code == 0))
		{
			NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSISOLatin2StringEncoding];
			
			char * thestart = (char*)[myResponse UTF8String];

			char * working = [MSBlancas findGetAnunciantesStart:thestart];
			char * end;
			if (working !=NULL)
			{
				end = [MSBlancas findGetAnunciantesEnd:working];
				if (end !=NULL)
				{
					end[0] =0x00;
					[thedictparameter setObject:[NSString stringWithUTF8String:working] forKey:@"anuncianteSeleccionado"];
					end[0] =' ';
				}					
			}
			

			thestart = (char*)[myResponse UTF8String];
			working = [MSBlancas findGetAbonadosStart:thestart];
			
			if (working !=NULL)
			{
				end = [MSBlancas findGetAbonadosEnd:working];
				if (end !=NULL)
				{
					end[0] =0x00;
					[thedictparameter setObject:[NSString stringWithUTF8String:working] forKey:@"abonadosSeleccionados"];
					end[0] =' ';
				}					
			}
			
			
			
			
			if ([MSBlancas complete:myResponse thearray:thearray] >0)
			{
				salida =YES;
			}
			else
			{
				salida =NO;
			}
		}
		
		
	}
	else 
	{
		if(id_provincia==0)
		{
			mystringURL = [NSString stringWithFormat:@"http://paginasblancas.com.ar/busqueda-nombre/argentina/%@-pagina-%d",[thedictparameter objectForKey:@"str"],pagina];
		}
		else 
		{
			mystringURL = [NSString stringWithFormat:@"http://paginasblancas.com.ar/busqueda-nombre/argentina/%@/%@-pagina-%d",[thedictparameter objectForKey:@"str_prov"],[thedictparameter objectForKey:@"str"],pagina];
		}
		
		

		
		
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setTimeoutInterval:15]; 
		[request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
		[request setURL:[NSURL URLWithString:mystringURL]];

		
		NSString *string =  [[NSString alloc] initWithString:@""];

		string = [string stringByAppendingString:[NSString stringWithFormat:@"paginado.paginaActual=%d",pagina]];
		string = [string stringByAppendingString:[NSString stringWithFormat:@"&apellido=%@",[thedictparameter objectForKey:@"str"]]];
		string = [string stringByAppendingString:[NSString stringWithFormat:@"&provinciasSeleccionadas=%d",id_provincia]];

		string = [string stringByAppendingString:[NSString stringWithFormat:@"&anunciantesSeleccionados=%@",@""]];

		string = [string stringByAppendingString:[NSString stringWithFormat:@"&anuncianteSeleccionado=%@",[thedictparameter objectForKey:@"anuncianteSeleccionado"]]];
		string = [string stringByAppendingString:[NSString stringWithFormat:@"&abonadosSeleccionados=%@",[thedictparameter objectForKey:@"abonadosSeleccionados"]]];



		
		
		NSNumber *length =[NSNumber numberWithUnsignedInteger:string.length];
		NSString *postLength = [length stringValue];
		[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"www.paginasblancas.com.ar" forHTTPHeaderField:@"Host"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
		[request setHTTPMethod:@"POST"];

		
		
		NSURLResponse *response;
		NSError *error=nil;
		NSData *d = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		if ( (d) && (error.code == 0))
		{
			NSString *myResponse = [ [NSString alloc] initWithData:d encoding:NSISOLatin2StringEncoding];
			if ([MSBlancas complete:myResponse thearray:thearray] >0)
			{
				salida =YES;
			}
			else
			{
				salida =NO;
			}
		}
		
		
		
	}

	
		return salida;


}









@end
