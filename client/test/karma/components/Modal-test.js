import React from 'react';
import { expect } from 'chai';
import { mount } from 'enzyme';

import Modal from '../../../app/components/Modal';

describe('Modal', () => {
  context('renders', () => {
    it('two buttons correctly', () => {
      let wrapper = mount(
        <Modal buttons={[{ classNames: ['test-class'],
          name: 'first' }]} visible title="Test Title">
          Test Content
        </Modal>
      );
      let buttonCount = 1;

      expect(wrapper.find('.cf-modal')).to.have.length(1);
      expect(wrapper.find('.test-class')).to.have.length(buttonCount);

      expect(
        wrapper.
          find('#Test-Title-button-id-0').
          hostNodes().
          hasClass('cf-push-right')
      ).to.equal(true);
    });

    it('three buttons correctly', () => {
      let wrapper = mount(
        <Modal
          buttons={[
            { classNames: ['test-class'],
              name: 'first' },
            { classNames: ['test-class'],
              name: 'second' },
            { classNames: ['test-class'],
              name: 'third' }
          ]}
          visible
          title="Test Title"
        >
          Test Content
        </Modal>
      );
      let buttonCount = 3;

      expect(wrapper.find('.cf-modal')).to.have.length(1);
      expect(wrapper.find('.test-class')).to.have.length(buttonCount);
      expect(
        wrapper.
          find('#Test-Title-button-id-0').
          hostNodes().
          hasClass('cf-push-left')
      ).to.equal(true);
      expect(
        wrapper.
          find('#Test-Title-button-id-1').
          hostNodes().
          hasClass('cf-push-right')
      ).to.equal(true);
      expect(
        wrapper.
          find('#Test-Title-button-id-2').
          hostNodes().
          hasClass('cf-push-right')
      ).to.equal(true);
    });
  });
});
