(function () { 
 
    // Create object that have the context information about the field that we want to change it's output render  
    var projectHealthContext = {}; 
    projectHealthContext.Templates = {}; 
    projectHealthContext.Templates.Fields = { 
        // Apply the new rendering for Priority field on List View 
        "Priority": { "View": projectHealthTemplate } 
    }; 
 
    SPClientTemplates.TemplateManager.RegisterTemplateOverrides(projectHealthContext); 
 
})(); 
 
// This function provides the rendering logic for list view 
function projectHealthTemplate(ctx) { 
    var projectHealth = ctx.CurrentItem[ctx.CurrentFieldSchema.ProjectHealth]; 
     
    switch (projectHealth) { 
        case "Green": 
            return "<img src='~site/SiteAssets/GreenLight.png' alt='Green Light'>"; 
            break; 
        case "Yellow": 
            return "<img src='~site/SiteAssets/YellowLight.png' alt='Yellow Light'>";
            break; 
        case "Red": 
            return "<img src='~site/SiteAssets/RedLight.png' alt='Red Light'>";
    } 
} 