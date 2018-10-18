import { timeFunction } from '../util/PerfDebug';
import { ACTIONS } from './constants';
import { update } from '../util/ReducerUtil';
import { combineReducers } from 'redux';

import caseListReducer from '../queue/CaseList/CaseListReducer';

export const initialState = {};

const hearingScheduleReducer = (state = initialState, action = {}) => {
  switch (action.type) {
  case ACTIONS.RECEIVE_HEARING_SCHEDULE:
    return update(state, {
      hearingSchedule: {
        $set: action.payload.hearingSchedule
      }
    });
  case ACTIONS.RECEIVE_PAST_UPLOADS:
    return update(state, {
      pastUploads: {
        $set: action.payload.pastUploads
      }
    });
  case ACTIONS.RECEIVE_SCHEDULE_PERIOD:
    return update(state, {
      schedulePeriod: {
        $set: action.payload.schedulePeriod
      }
    });
  case ACTIONS.RECEIVE_REGIONAL_OFFICES:
    return update(state, {
      regionalOffices: {
        $set: action.payload.regionalOffices
      }
    });
  case ACTIONS.RECEIVE_DAILY_DOCKET:
    return update(state, {
      dailyDocket: {
        $set: action.payload.dailyDocket
      }
    });
  case ACTIONS.REGIONAL_OFFICE_CHANGE:
    return update(state, {
      selectedRegionalOffice: {
        $set: action.payload.regionalOffice
      }
    });
  case ACTIONS.RECEIVE_UPCOMING_HEARING_DAYS:
    return update(state, {
      upcomingHearingDays: {
        $set: action.payload.upcomingHearingDays
      }
    });
  case ACTIONS.RECEIVE_VETERANS_READY_FOR_HEARING:
    return update(state, {
      veteransReadyForHearing: {
        $set: action.payload.veterans
      }
    });
  case ACTIONS.SELECTED_HEARING_DAY_CHANGE:
    return update(state, {
      selectedHearingDay: {
        $set: action.payload.selectedHearingDay
      }
    });
  case ACTIONS.SCHEDULE_PERIOD_ERROR:
    return update(state, {
      spErrorDetails: {
        $set: action.payload.error
      },
      schedulePeriodError: {
        $set: true
      }
    });
  case ACTIONS.REMOVE_SCHEDULE_PERIOD_ERROR:
    return update(state, {
      $unset: ['schedulePeriodError']
    });
  case ACTIONS.SET_VACOLS_UPLOAD:
    return update(state, {
      vacolsUpload: {
        $set: true
      }
    });
  case ACTIONS.UPDATE_UPLOAD_FORM_ERRORS:
    return update(state, {
      uploadFormErrors: {
        $set: action.payload.errors
      }
    });
  case ACTIONS.UPDATE_RO_CO_UPLOAD_FORM_ERRORS:
    return update(state, {
      uploadRoCoFormErrors: {
        $set: action.payload.errors
      }
    });
  case ACTIONS.UPDATE_JUDGE_UPLOAD_FORM_ERRORS:
    return update(state, {
      uploadJudgeFormErrors: {
        $set: action.payload.errors
      }
    });
  case ACTIONS.UNSET_UPLOAD_ERRORS:
    return update(state, {
      $unset: [
        'uploadRoCoFormErrors',
        'uploadJudgeFormErrors'
      ]
    });
  case ACTIONS.FILE_TYPE_CHANGE:
    return update(state, {
      fileType: {
        $set: action.payload.fileType
      },
      $unset: ['uploadFormErrors']
    });
  case ACTIONS.RO_CO_START_DATE_CHANGE:
    return update(state, {
      roCoStartDate: {
        $set: action.payload.startDate
      }
    });
  case ACTIONS.RO_CO_END_DATE_CHANGE:
    return update(state, {
      roCoEndDate: {
        $set: action.payload.endDate
      }
    });
  case ACTIONS.RO_CO_FILE_UPLOAD:
    return update(state, {
      roCoFileUpload: {
        $set: action.payload.file
      }
    });
  case ACTIONS.JUDGE_START_DATE_CHANGE:
    return update(state, {
      judgeStartDate: {
        $set: action.payload.startDate
      }
    });
  case ACTIONS.JUDGE_END_DATE_CHANGE:
    return update(state, {
      judgeEndDate: {
        $set: action.payload.endDate
      }
    });
  case ACTIONS.VIEW_START_DATE_CHANGE:
    return update(state, {
      viewStartDate: {
        $set: action.payload.viewStartDate
      }
    });
  case ACTIONS.VIEW_END_DATE_CHANGE:
    return update(state, {
      viewEndDate: {
        $set: action.payload.viewEndDate
      }
    });
  case ACTIONS.JUDGE_FILE_UPLOAD:
    return update(state, {
      judgeFileUpload: {
        $set: action.payload.file
      }
    });
  case ACTIONS.TOGGLE_UPLOAD_CONTINUE_LOADING:
    return update(state, {
      $toggle: ['uploadContinueLoading']
    });
  case ACTIONS.CLICK_CONFIRM_ASSIGNMENTS:
    return update(state, {
      displayConfirmationModal: {
        $set: true
      }
    });
  case ACTIONS.CLICK_CLOSE_MODAL:
    return update(state, {
      displayConfirmationModal: {
        $set: false
      }
    });
  case ACTIONS.CONFIRM_ASSIGNMENTS_UPLOAD:
    return update(state, {
      displaySuccessMessage: {
        $set: true
      },
      $unset: [
        'fileType',
        'roCoStartDate',
        'roCoEndDate',
        'roCoFileUpload',
        'judgeStartDate',
        'judgeEndDate',
        'judgeFileUpload',
        'vacolsUpload'
      ]
    });
  case ACTIONS.UNSET_SUCCESS_MESSAGE:
    return update(state, {
      $unset: [
        'displaySuccessMessage',
        'schedulePeriod',
        'vacolsUpload'
      ]
    });
  case ACTIONS.TOGGLE_TYPE_FILTER_DROPDOWN:
    return update(state, {
      $toggle: ['filterTypeIsOpen']
    });
  case ACTIONS.TOGGLE_LOCATION_FILTER_DROPDOWN:
    return update(state, {
      $toggle: ['filterLocationIsOpen']
    });
  case ACTIONS.TOGGLE_VLJ_FILTER_DROPDOWN:
    return update(state, {
      $toggle: ['filterVljIsOpen']
    });
  default:
    return state;
  }
};

const combinedReducer = combineReducers({
  hearingSchedule: hearingScheduleReducer,
  caseList: caseListReducer
});

export default timeFunction(
  combinedReducer,
  (timeLabel, state, action) => `Action ${action.type} reducer time: ${timeLabel}`
);
