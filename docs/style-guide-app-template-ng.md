# Angular App Template Style Guide

## What is a NativeScript App Template?
The NativeScript app template is a blueprint for a fully functional mobile application developed with NativeScript. Each app template resides in its own git repo (e.g. [https://github.com/NativeScript/template-master-detail-ng](https://github.com/NativeScript/template-master-detail-ng)) and is usually published as an npm package as well (e.g. [https://www.npmjs.com/package/tns-template-master-detail-ng](https://github.com/NativeScript/template-master-detail-ng)). You use the tns create CLI command to create mobile app from app template like this:
```
tns create my-app-name --template tns-template-master-detail-ng 
```
OR 
```
tns create my-app-name --template https://github.com/NativeScript/template-master-detail-ng
```
Progress Software develops and maintains a number of app templates but you can also create templates that suit your business requirements with ease. The purpose of this document is to provide an opinionated guide for app template development that ensures a level of consistency, maintainability, and ease of use for the developer that consumes the app template product (no matter whether it is developed by Progress Software, or not).

## Style Vocabulary
Each guideline describes either a good or bad practice, and all have a consistent presentation.  

**Do** is one that should always be followed. Always might be a bit too strong of a word. Guidelines that literally should always be followed are extremely rare. On the other hand, you need a really unusual case for breaking a Do guideline.

**Consider** guidelines should generally be followed. If you fully understand the meaning behind the guideline and have a good reason to deviate, then do so. Please strive to be consistent.

**Avoid** indicates something you should never do.

## Getting started
Consider using the following workflow to facilitate app template development, testing, and debugging:  
* Clone the [seed template](https://github.com/NativeScript/template-blank-ng) git repo locally to [work-folder]\template-blank-ng:
```
git clone git@github.com:NativeScript/template-blank-ng.git
```  
* Execute `tns create` CLI command to create an app from **the same template** to [work-folder]\blank-ng:
```
tns create blank-ng --template tns-template-blank-ng
```
* Save the contents of [work-folder]\blank-ng\app\package.json somewhere in text editor (you will need them in a bit).  

* Delete the whole [work-folder]\blank-ng\app folder.  

* Using [Link Shell Extension](http://schinagl.priv.at/nt/hardlinkshellext/linkshellextension.html) (for Windows) create symbolic link to [work-folder]\template-blank-ng (the git-controlled folder created above) in [work-folder]\blank-ng and rename [work-folder]\blank-ng\template-blank-ng to [work-folder]\blank-ng\app.  

* Replace what is in [work-folder]\blank-ng\app\package.json with the contents you saved aside above (this effectively modifies [work-folder]\template-blank-ng\package.json as well so **make sure you do not commit this change to git** -- this is a local change that allows you to actually `tns run android` or `tns run ios` the app from the [work-folder]\blank-ng folder).

Now you can develop / deploy / debug your app template from [work-folder]\blank-ng, then you can commit changes to git from [work-folder]\template-blank-ng.  

**Be cautious!**
- You have to be extra careful when committing changes to git as you don't want to commit the local "dev" changes in [work-folder]\template-blank-ng\package.json (symlinked to [work-folder]\blank-ng\app\package.json) as this will break the `tns create` CLI command for your git-controlled template. 
- Make sure not to commit changes to [work-folder]\template-blank-ng\App_Resources\Android\app.gradle (or any other App_Resources file modified in the symlinked copy when tns-running the app) either.
- If you want to commit actual changes to the [work-folder]\template-blank-ng\package.json file (e.g. new dependencies to the git-controlled template) you will have to make them in two places -- modify [work-folder]\blank-ng\package.json (not symlinked!) to tns-run and test the changes locally and modify [work-folder]\template-blank-ng\package.json to commit them.

## App Template Structure and NgModules
* Do create folders named for the feature area they represent.  
Each feature area should be placed in a separate folder in the template's folder structure.

* Do place each component, service, and model in its own file.  
Apply the [single responsibility principle (SRP)](https://wikipedia.org/wiki/Single_responsibility_principle) to all components, services, and other symbols. This helps make the app cleaner, easier to read and maintain, and more testable.

* Consider creating a folder for a component when it has multiple accompanying files (.ts, .html, .scss/css, etc.).

* Avoid putting all of your app template's code in a root folder named "app".  
When the actual app is created from the template, all of the template's code will indeed go inside a root "app" folder but you MUST NOT define this folder in the hierarchy of your template; otherwise the tns create CLI command will not function properly.

### App Root Module
* Do create an NgModule in the template's root folder.

* Consider naming the root module **app.module.ts**.

### Feature Modules
* Do create an NgModule for all distinct features in an application; for example, **cars** feature.

* Do place the feature module in the same named folder as the feature area; for example, in folder **cars**.

* Do name the feature module file reflecting the name of the feature area and folder; for example, **cars/cars.module.ts**.

* Do name the feature module symbol reflecting the name of the feature area, folder, and file; for example, **cars/cars.module.ts** defines **CarsModule**.

### Shared Feature Module
* Do create a feature module named **SharedModule** in a shared folder; for example, **shared/shared.module.ts** defines **SharedModule**.

* Do declare components, directives, and pipes in a shared module when those items will be re-used and referenced by the components declared in other feature modules.

* Consider using the name **SharedModule** when the contents of a shared module are referenced across the entire application.

* Avoid providing services in shared modules. Services are usually singletons that are provided once for the entire application or in a particular feature module.

* Do import all modules required by the assets in the **SharedModule**; for example, **NativeScriptUISideDrawerModule** if you have defined a drawer in the shared module.

* Do export all symbols from the **SharedModule** that other feature modules need to use.

* Avoid specifying app-wide singleton providers in a **SharedModule**.

### Core Feature Module
* Consider collecting numerous, auxiliary, single-use classes inside a core module to simplify the apparent structure of a feature module.

* Consider calling the application-wide core module, **CoreModule**. Importing **CoreModule** into the root AppModule reduces its complexity and emphasizes its role as orchestrator of the application as a whole.

* Do create a feature module named **CoreModule** in a core folder (e.g. **core/core.module.ts** defines **CoreModule**).

* Do put a singleton service whose instance will be shared throughout the application in the **CoreModule** (e.g. **ExceptionService** and **LoggerService**).

* Do import all modules required by the assets in the **CoreModule**.

* Do gather application-wide, single use components in the **CoreModule**. Import it once (in the **AppModule**) when the app starts and never import it anywhere else.

* Avoid importing the **CoreModule** anywhere except in the **AppModule**.

* Do export all symbols from the **CoreModule** that the **AppModule** will import and make available for other feature modules to use.

### Lazy-loaded Folders
* Do put the contents of lazy loaded features in a lazy loaded folder. A typical lazy loaded folder contains a routing component, its child components, and their related assets and modules.

* Avoid allowing modules in sibling and parent folders to directly import a module in a lazy loaded feature.

## Package.json Guidelines
* Do place a package.json file in the root folder of your app template.  
Note this is not the actual root package.json of the generated mobile app – it is only used by the `tns create` CLI command upon app creation. Do not expect that everything you place in your package.json will be transferred to the actual package.json file. Notably `scripts` property content is removed, however, if you provide preinstall / postinstall scripts they will be executed before getting removed. You can use this mechanism to generate / move settings files to the root folder of the generated app and/or generate actual "scripts" content for the resulting app package.json – see [copying settings files](https://github.com/NativeScript/template-master-detail-ng/blob/master/tools/preinstall.js) and [generating `scripts` commands on-the-fly](https://github.com/NativeScript/template-master-detail-ng/blob/master/tools/postinstall.js) for concrete examples.

* Do provide a value for the `name` property using the format: **tns-template-[custom-template-name-goes-here]-ng**.  
Note this property value is NOT transferred to the root package.json file generated by the tns create CLI command but can be found in the app/package.json file of the generated app.

* Do provide a value for the `version` property following semver rules (e.g. 1.0.0).  
Note this property value is NOT transferred to the root package.json file generated by the tns create CLI command but can be found in the app/package.json file of the generated app.

* Do provide a value for the `main` property specifying the primary entry point to your app (usually **main.js**).  
Note this property value is NOT transferred to the root package.json file generated by the tns create CLI command but can be found in the app/package.json file of the generated app.

* Do provide a value for the `android` property specifying V8 flags (at a minimum it should be set to `"android": { "v8Flags": "--expose_gc" }`).  
Note this property value is NOT transferred to the root package.json file generated by the tns create CLI command but can be found in the app/package.json file of the generated app.

* Do provide a value for the `displayName` property (user-friendly template name to be used in a future integration with NativeScript Sidekick).  
Note this property value is NOT transferred to the root package.json file generated by the tns create CLI command.

* Do provide a value for the `repository` property specifying the place where your code lives.
 	- Note this property value is NOT transferred to the root package.json file generated by the tns create CLI command.

 	- Note correct `repository` property value is essential for the future integration with NativeScript Marketplace. Check the following section “Marketplace guidelines” for other integration requirements as well.

* Do provide a value for the following additional set of package.json properties: `description`, `license`, `readme`, `dependencies`, `devDependencies`.  
Note these property values are transferred to the root package.json file generated by the tns create CLI command.
For example https://github.com/NativeScript/template-master-detail-ng/blob/master/package.json has the following minimal structure:
```
{ 
	"name": "tns-template-master-detail-ng", 
	"displayName": "Master-Detail with Firebase", 
	"main": "main.js", 
	"version": "3.2.1", 
	"description": "Master-detail interface to display collection of items from Firebase and inspect and edit selected item properties. ", 
	"license": "SEE LICENSE IN <your-license-filename>", 
	"readme": "NativeScript Application", 
	"repository": { 
		"type": "git", 
		"url": "https://github.com/NativeScript/template-master-detail-ng" 
	}, 
	"android": { 
		"v8Flags": "--expose_gc" 
	}, 
	"dependencies": { 
		... 
	}, 
	"devDependencies": { 
		... 
	} 
}
```

## Styling
* Consider using the [NativeScript core theme](https://github.com/NativeScript/theme) for styling your app template.

* Consider using SASS for styling your app template.

* Consider using the following infrastructure to enable cross-platform SASS styling for your app template:  
**_app-variables.scss** file in the app template's root folder should import the NativeScript core theme variables and any custom colors or theme variable overrides you might use:
``` scss
// Import the theme's variables. If you're using a color scheme 
// other than "light", switch the path to the alternative scheme, 
// for example '~nativescript-theme-core/scss/dark'. 
@import '~nativescript-theme-core/scss/light'; 

// Custom colors 
$blue-dark: #022734 !default; 
$blue-light: #02556E !default; 
$blue-50: rgba($blue-dark, 0.5) !default; 

// ... 

/** 
* Theme variables overrides 
**/ 

// Colors 
$background: #fff; 
$primary: lighten(#000, 13%); 

// ...
```


**_app-common.scss** file in the app template's root folder should contain any styling rules to be applied both on iOS and Android:
``` scss
// Place any CSS rules you want to apply on both iOS and Android here. 
// This is where the vast majority of your CSS code goes. 
//Font icon
.fa {
   font-family: "FontAwesome";
}
//Action bar
.action-item,
NavigationButton {
    color: $ab-color;
}

// ...
```

**app.android.scss** file in the app template's root folder should import the app variables, the NativeScript core theme main ruleset, and the common styles; also place any styling rules to be applied only on Android here:
``` scss
// Import app variables
@import 'app-variables';

// Import the theme’s main ruleset - both index and platform specific.
@import '~nativescript-theme-core/scss/index';
@import '~nativescript-theme-core/scss/platforms/index.android';

// Import common styles
@import 'app-common';

// Place any CSS rules you want to apply only on Android here
.action-item {
    padding-right: 10;
}

// ...
```

**app.ios.scss** file in the app template's root folder should import the app variables, the NativeScript core theme main ruleset, and the common styles; also place any styling rules to be applied only on iOS here:
``` scss
// Import app variables
@import 'app-variables';

// Import the theme’s main ruleset - both index and platform specific.
@import '~nativescript-theme-core/scss/index';
@import '~nativescript-theme-core/scss/platforms/index.ios';

// Import common styles
@import 'app-common';

// Place any CSS rules you want to apply only on iOS here

// ...
```

* Consider using the following infrastructure to enable cross-platform SASS styling on component level:
**_[component-name].component.scss** in the respective feature folder should contain the style rules to be applied both on iOS and Android for **[component-name].component.ts** (e.g. if styling **cars/car-list.component.ts**, the file should be **cars/_car-list.component.scss**):
``` scss
// Start custom common variables
@import '../app-variables';
// End custom common variables

// Custom styles
.list-group {
    .list-group-item {
        padding: 0 0 8 0;
        background-color: $blue-10;
    }
}

// ...
```

**[component-name].component.android.scss** in the respective feature folder should contain the style rules to be applied only on Android for **[component-name].component.ts** (e.g. if styling **cars/car-list.component.ts**, the file should be **cars/car-list.component.android.scss**):
``` scss
@import 'car-list.component'; 

// Place any CSS rules you want to apply only on Android here 

// ...
```

**[component-name].component.ios.scss** in the respective feature folder should contain the style rules to be applied only on iOS for **[component-name].component.ts** (e.g. if styling **cars/car-list.component.ts**, the file should be **cars/car-list.component.ios.scss**):
``` scss
@import 'car-list.component'; 

// Place any CSS rules you want to apply only on iOS here 

// ...
```

NOTE you should import the compiled **[component-name].component.css** file (NOT **[component-name].component.scss**) in your component e.g. if styling **cars/car-list.component.ts**, the file should be **cars/car-list.component.css**:
``` ts
@Component({
    selector: "CarsList",
    moduleId: module.id,
    templateUrl: "./car-list.component.html",
    styleUrls: ["./car-list.component.css"]
})
export class CarListComponent implements OnInit { 
// ... 
}
```

## Components
### Component Selector Names
* Do use a PascalCase element selector value (e.g. **CarDetail**)
``` ts
@Component({
    selector: "CarDetail",
    moduleId: module.id,
    templateUrl: "./car-detail.component.html"
})
export class CarDetailComponent implements OnInit { 
// ... 
}
```

### Components as Elements
* Do give components an element selector, as opposed to attribute or class selectors.

### Extract Templates and Styles to Their Own Files
* Do extract templates and styles into a separate file, when more than 3 lines.

### Decorate Input and Output Properties
* Do use the @Input() and @Output() class decorators instead of the inputs and outputs properties of the @Directive and @Component metadata.

* Consider placing @Input() or @Output() on the same line as the property it decorates.

### Member Sequence
* Do place properties up top followed by methods.

### Delegate Complex Component Logic to Services
* Do limit logic in a component to only that required for the view. All other logic should be delegated to services.

* Do move reusable logic to services and keep components simple and focused on their intended purpose.

### Don't Prefix Output Properties
* Do name events without the prefix **on**.

* Do name event handler methods with the prefix **on** followed by the event name.

## Services
### Services Are Singletons
* Do use services as singletons within the same injector. Use them for sharing data and functionality.

### Single Responsibility
* Do create services with a single responsibility that is encapsulated by its context.

* Do create a new service once the service begins to exceed that singular purpose.

### Providing a Service
* Do provide services to the Angular injector at the top-most component where they will be shared.

### Use the @Injectable() Class Decorator
* Do use the @Injectable() class decorator instead of the @Inject parameter decorator when using types as tokens for the dependencies of a service.

## Data Services
### Talk to the Server through a Service
* Do refactor logic for making data operations and interacting with data to a service.

* Do make data services responsible for XHR calls, local storage, stashing in memory, or any other data operations.

### Lifecycle Hooks
* Do implement the lifecycle hook interfaces.

## Coding Conventions
* Consider using tslint and the [tslint.json ruleset](https://github.com/NativeScript/template-master-detail-ng/blob/master/tools/tslint.json) provided by Progress Software to ensure maximum consistency with the standard app templates.

### Classes
* Do use upper camel case when naming classes.

### Variables and Constants
* Do declare variables with let instead of var.

* Do declare variables with const if their values should not change during the application lifetime.

* Consider spelling const variables in lower camel case.

* Do tolerate existing const variables that are spelled in UPPER_SNAKE_CASE.

### Properties and Methods
* Do use lower camelcase to name properties and methods.

* Do declare return type for methods explicitly.

* Do use the return type **void** for methods whose value will be ignored.

* Avoid using the return type **any** for methods whose value will be ignored.

### Import Line Spacing
* Consider leaving one empty line between third party imports and application imports.

* Consider listing import lines alphabetized by the module.

* Consider listing destructured imported symbols alphabetically.

## Naming
### General Naming Guidelines
* Do use consistent names for all symbols.

* Do use dashes to separate words in the descriptive name.

* Do use dots to separate the descriptive name from the type.

* Do follow a pattern that describes the symbol's feature then its type. The recommended pattern is **feature.type.ts**.

* Do use conventional type names including .service, .component, , .module, and .model. Invent additional type names if you must but take care not to create too many.
```
car-detail.component.ts 
car-detail.component.html 
cars-routing.module.ts 
cars.module.ts 
car.model.ts 
car.service.ts
```

### Symbols and File Names
* Do use consistent names for all assets named after what they represent.

* Do use upper camel case for class names.

* Do match the name of the symbol to the name of the file.

* Do append the symbol name with the conventional suffix (such as Component, Module, Service) for a thing of that type.

| Symbol Name  | File Name |
| ------------- | ------------- |
| @Component({...}) export class CarDetailComponent { }  | car-detail.component.ts  |
| @Component({...}) export class CarsModule { }  | cars.module.ts  |
| @Injectable() export class CarService { }  | car.service.ts  |

### Service Names
* Do use consistent names for all services named after their feature.

* Do suffix a service class name with Service. For example, something that gets data or cars should be called a **DataService** or a **CarService**.  
A few terms are unambiguously services. They typically indicate agency by ending in "-er". You may prefer to name a service that logs messages Logger rather than LoggerService. Decide if this exception is agreeable in your project. As always, strive for consistency.

### Bootstrapping
* Do put bootstrapping and platform logic for the app in a file named **main.ts**.

* Avoid putting app logic in **main.ts**. Instead, consider placing it in a component or service.

### Custom Prefix for Components
* Consider using a PascalCase element selector value (e.g. **CarDetail**)

* Do use a prefix that identifies the feature area or the app itself.

### Angular NgModule names
* Do append the symbol name with the suffix Module.

* Do give the file name the .module.ts extension.

* Do name the module after the feature and folder it resides in.

* Do suffix a RoutingModule class name with RoutingModule.

* Do end the filename of a RoutingModule with -routing.module.ts.

## NativeScript Marketplace Guidelines

[Read more](https://github.com/NativeScript/marketplace-feedback/blob/master/docs/template-submission.md) how to submit your app template to  [NativeScript Marketplace](https://market.nativescript.org).

## More Guidelines

* [Read TypeScript App Template Style Guide](https://github.com/NativeScript/nativescript-starter-kits-utils/blob/master/docs/style-guide-app-template-ts.md)

* [Read Angular App Template Style Guide](https://github.com/NativeScript/nativescript-starter-kits-utils/blob/master/docs/style-guide-app-template-ng.md)
