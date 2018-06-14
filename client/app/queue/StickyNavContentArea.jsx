import { css } from 'glamor';
import React from 'react';

import StringUtil from '../util/StringUtil';
import { COLORS } from '../constants/AppConstants';

const sectionNavigationContainerStyling = css({
  float: 'left',
  paddingRight: '3rem',
  position: 'sticky',
  top: '3rem',
  width: '20%'
});

const sectionNavigationListStyling = css({
  '& > li': {
    backgroundColor: COLORS.GREY_BACKGROUND,
    color: COLORS.PRIMARY,
    borderWidth: 0
  },
  '& > li:hover': {
    backgroundColor: COLORS.GREY_DARK,
    color: COLORS.WHITE
  },
  '& > li > a': { color: COLORS.PRIMARY },
  '& > li:hover > a': {
    background: 'none',
    color: COLORS.WHITE
  },
  '& > li > a:after': {
    content: '〉',
    float: 'right'
  }
});

const sectionBodyStyling = css({
  float: 'left',
  width: '80%'
});

const getIdForElement = (elem) => `${StringUtil.parameterize(elem.props.title)}-section`;

export default class StickyNavContentArea extends React.PureComponent {
  render = () => {
    // Ignore undefined child elements.
    const childElements = this.props.children.filter((child) => typeof child === 'object');

    return <React.Fragment>
      <aside {...sectionNavigationContainerStyling}>
        <ul className="usa-sidenav-list" {...sectionNavigationListStyling}>
          {childElements.map((child, i) =>
            <li key={i}><a href={`#${getIdForElement(child)}`}>{child.props.title}</a></li>)}
        </ul>
      </aside>

      <div {...sectionBodyStyling}>
        {childElements.map((child, i) => <ContentSection key={i} element={child} />)}
      </div>
    </React.Fragment>;
  };
}

const sectionSegmentStyling = css({
  border: `1px solid ${COLORS.GREY_LIGHT}`,
  borderTop: '0px',
  marginBottom: '3rem',
  padding: '1rem 2rem'
});

const sectionHeadingStyling = css({
  backgroundColor: COLORS.GREY_BACKGROUND,
  border: `1px solid ${COLORS.GREY_LIGHT}`,
  borderBottom: 0,
  borderRadius: '0.5rem 0.5rem 0 0',
  margin: 0,
  padding: '1rem 2rem'
});

const ContentSection = ({ element }) => <React.Fragment>
  <h2 id={`${getIdForElement(element)}`} {...sectionHeadingStyling}>{element.props.title}</h2>
  <div {...sectionSegmentStyling}>{element}</div>
</React.Fragment>;

