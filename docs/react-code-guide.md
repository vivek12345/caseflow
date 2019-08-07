## Principles

- Readable components

    → at first glance, a dev should should know 1. what a component does and 2. how to use it (e.g what props to pass it)

- Maximize component reusability

    → either across app and within an app, components should be modular so that they can be easily reorganized or refactored for use in multiple places

- Separation of presentation from logic / behavior

    → Caseflow's workflows can be very complicated. It's important that we have a clean separation between how components are styled and defined and how they are composed to create an application

## Directory Structure

template for organizing a Caseflow react app
```
└── client
    ├── app
    │   ├── index.js
    │   └── <app_name>
    │       ├── index.js
    │       ├── routes.js
    │       ├── constants.js
    │       ├── reducers.js
    │       ├── utils.js
    │       ├── components
    │       │   ├── index.js
    │       │   ├── Component1.js
    │       │   └── Component2
    │       │       ├── Component2.js
    │       │       ├── Component2SpecificComponent.js
    │       │       └── style.js
    │       └── pages
    │           └── page1
    │               ├── page1.js
    │               ├── reducers.js
    │               ├── actions.js
    │               ├── constants.js
    │               └── Page1SpecificContainerComponent1.js
    ├── components
    ├── utils
    └── constants
```

- `components/` - defines all presentational components (e.g inputs, modals, styled components)

    → `index.js` - exports all components from the directory
      ```javascript
        export Component1 from './Component1';
        export Component2 from './Component2/Component2.js';
      ```

    this allows us to access all components in a directory easily
      ```javascript
        import { Component2 } from '../../components';
      ```

- `pages` - generally map to `routes`.

    → analogous to what some Caseflow apps call `containers/`

    → redux `reducers` , `actions` , and `constants` should be defined in the directory for the page(s) that use them

## General Conventions

- Consider 3 places to manage actions / state ⇒ a `Container` `ReduxStore` `Context`

    → `Container` - A container defines all the actions that can take place for a component and it's children. At first glance, a dev should be able to read a Container's state and methods and understand what the components does without knowing the details of its presentation. Use liberally. You should almost alway use a Stateful "container" to manage actions/state.

    → `ReduxStore` - use sparingly when changes in the state impact unrelated components or the entire application (e.g. user data, loading status)

    → `Context` (required 16.8.0 upgrade) - Also use sparingly / consider refactoring before using. Use when deeply nested stateless components require props from a Container

- **??** Can we be consistent about how / where data is loaded through AJAX? It sometimes difficult to know what component is loading data for a given page **??**
- If a render function requires nesting more than 2 levels, refactor nested components into stateless components
- Avoid using Higher Order Components

    → Higher order components obscure application logic and data and can make components harder to reason about. Consider refactoring components to take additional props rather than wrapping components to add new props / functionality.

    → Alternatively consider

- don't use class-based getter methods to define a component
  ```javascript
    // do this

    const StatelessComponent = () => (
    	<div></div>
    );

    // not this

    class StatefulComponent extends React.Component {
    	getStatelessComponent = () => (
    		<div></div>
    	)
    }
  ```

## Style

- `pages/` / containers should have very little style
- use inline styles for `components`
- create style objects with `glamor`

    → If styles are long or complicated, consider creating `style.js` file in the component's directory
      ```javascript
        // client/<app_name>/components/Component2/style.js
        import glamor from 'glamor';

        export const componentStyle1 = glamor({});
        export const componentStyle2 = glamor({});
      ```

### Can We SPA?

- Is the only barrier the fact that we load page-specific data into `react_rails` through a template? Can we move those to ajax calls and refactor routes?
