import React from 'react';
import PropTypes from 'prop-types';

import { Tabs } from './tabs/Tabs';
import { Tab } from './tabs/Tab';

/*
 * This component can be used to easily build tabs.
 * The required props are:
 * - @tabs {array[string]} array of strings placed in the tabs at the top
 * of the window
 * - @pages {array[node]} array of nodes displayed when the corresponding
 * tab is selected
 * Optional props:
 * - @name {string} used in each tab ID to differentiate multiple sets of tabs
 * on a page. This is for accessibility purposes.
 */
const TabWindow = ({
  fullPage = false,
  defaultPage = 0,
  name = 'main',
  onChange,
  tabs = [],
}) => {
  const tabContent = (tab) => (
    <span>
      {tab.icon ?? ''}
      <span>{tab.label}</span>
      {tab.indicator ?? ''}
    </span>
  );

  return (
    <Tabs
      fullWidth={fullPage}
      idPrefix={name}
      active={defaultPage.toString()}
      onChange={onChange}
    >
      {tabs.map((item, idx) => (
        <Tab
          title={tabContent(item)}
          key={idx}
          value={idx}
          disabled={Boolean(item.disable)}
        >
          {item.page}
        </Tab>
      ))}
    </Tabs>
  );
};

// export default class TabWindow extends React.Component {
//   constructor(props) {
//     super(props);
//     this.state = {
//       currentPage: this.props.defaultPage || 0,
//       disabled: false,
//     };
//   }

//   onTabClick = (tabNumber) => () => {
//     this.setState({
//       currentPage: tabNumber,
//     });

//     if (this.props.onChange) {
//       this.props.onChange(tabNumber);
//     }
//   };

//   getTabHeaderWithSVG = (tab) => {
//     return (
//       <span>
//         {tab.icon ? tab.icon : ''}
//         <span>{tab.label}</span>
//         {tab.indicator ? tab.indicator : ''}
//       </span>
//     );
//   };

//   getTabHeader = (tab) => {
//     return `${tab.label} tab window`;
//   };

//   getTabClassName = (index, currentPage, isTabDisabled) => {
//     let className = `cf-tab${index === currentPage ? ' cf-active' : ''}`;

//     className += isTabDisabled ? ' disabled' : '';

//     return className;
//   };

//   // For pages with only one set of tabs or a non-specified tab group name
//   // the name returns "undefined". This appends the word "main" to the tab group.
//   getTabGroupName = (name) => {
//     return name ? name : 'main';
//   };

//   render() {
//     const { name, tabs, fullPage, bodyStyling } = this.props;

//     return (
//       <div>
//         {tabs?.length > 1 && (
//           <div
//             role="tablist"
//             className={`cf-tab-navigation${
//               fullPage ? ' cf-tab-navigation-full-screen' : ''
//             }`}
//           >
//             {tabs.map((tab, i) => (
//               <button
//                 className={this.getTabClassName(
//                   i,
//                   this.state.currentPage,
//                   tab.disable
//                 )}
//                 key={i}
//                 id={`${this.getTabGroupName(name)}-tab-${i}`}
//                 onClick={this.onTabClick(i)}
//                 aria-label={this.getTabHeader(tab)}
//                 disabled={Boolean(tab.disable)}
//                 role="tab"
//                 aria-selected={this.state.currentPage === i}
//                 aria-controls={`tab-panel-${i}`}
//                 tabIndex={this.state.currentPage !== i ? -1 : undefined}
//               >
//                 <span>{this.getTabHeaderWithSVG(tab)}</span>
//               </button>
//             ))}
//           </div>
//         )}
//         {tabs?.length && (
//           <div
//             id="tab-panel-container"
//             className={cx([
//               'cf-tab-window-body-full-screen',
//               classes.tabContent,
//             ])}
//             {...bodyStyling}
//           >
//             {tabs.map((tab, i) => (
//               <div
//                 id={`tab-panel-${i}`}
//                 role="tabpanel"
//                 aria-labelledby={`${this.getTabGroupName(name)}-tab-${i}`}
//                 aria-hidden={this.state.currentPage !== i}
//                 className={cx(classes.tabPane, {
//                   show: this.state.currentPage === i,
//                 })}
//                 key={i}
//               >
//                 {tab.page}
//               </div>
//             ))}
//           </div>
//         )}
//       </div>
//     );
//   }
// }

TabWindow.propTypes = {
  bodyStyling: PropTypes.object,
  fullPage: PropTypes.bool,
  name: PropTypes.string,
  onChange: PropTypes.func,
  tabs: PropTypes.arrayOf(
    PropTypes.shape({
      disable: PropTypes.bool,
      icon: PropTypes.obj,
      indicator: PropTypes.obj,
      label: PropTypes.node.isRequired,
      page: PropTypes.node.isRequired,
    })
  ),
  defaultPage: PropTypes.number,
};

TabWindow.defaultProps = {
  defaultPage: 0,
  fullPage: false,
};

export default TabWindow;
