local _, NeP = ...
NeP.Interface = {}

NeP.Interface.statusBarStylesheet = {
  ['frame-texture'] = {
    type		= 'texture',
    layer		= 'BORDER',
    gradient	= 'VERTICAL',
    color		= '000000',
    alpha 		= 0.7,
    alphaEnd	= 0.1,
    offset		= 0,
  }
}

NeP.Interface.buttonStyleSheet = {
	['frame-color'] = {
		type			= 'texture',
		layer			= 'BACKGROUND',
		color			= '2f353b',
		offset		= 0,
	},
	['frame-highlight'] = {
		type			= 'texture',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',
		color			= 'FFFFFF',
		alpha 		= 0,
		alphaEnd	= .1,
		offset		= -1,
	},
	['frame-outline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		color			= '000000',
		offset		= 0,
	},
	['frame-inline'] = {
		type			= 'outline',
		layer			= 'BORDER',
		gradient	= 'VERTICAL',
		color			= 'ffffff',
		alpha 		= .02,
		alphaEnd	= .09,
		offset		= -1,
	},
	['frame-hover'] = {
		type			= 'texture',
		layer			= 'HIGHLIGHT',
		color			= 'ffffff',
		alpha			= .1,
		offset		= 0,
	},
	['text-color'] = {
		type			= 'Font',
		color			= 'b8c2cc',
	},
}

NeP.Interface.createButtonStyle = {
	type			= 'texture',
	texFile		= 'DiesalGUIcons',
	texCoord		= {1,6,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}

NeP.Interface.deleteButtonStyle = {
	type			= 'texture',
	texFile		='DiesalGUIcons',
	texCoord		= {2,6,16,256,128},
	alpha 		= .7,
	offset		= {-2,nil,-2,nil},
	width			= 16,
	height		= 16,
}
