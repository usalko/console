// This file is part of MinIO Console Server
// Copyright (c) 2023 MinIO, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import React, { Fragment } from "react";
import { useIntl } from 'react-intl';
import { useSelector } from "react-redux";
import { AddIcon, DocumentationIcon, LicenseIcon, Menu, MenuItem } from "mds";
import { AppState, useAppDispatch } from "../../../store";
import { menuOpen } from "../../../systemSlice";
import { getLogoApplicationVariant, getLogoVar } from "../../../config";
import { useLocation, useNavigate } from "react-router-dom";
import { IAM_PAGES } from "../../../common/SecureComponent/permissions";
import { setAddBucketOpen } from "../Buckets/ListBuckets/AddBucket/addBucketsSlice";
import BucketsListing from "./Listing/BucketsListing";
import { getLicenseConsent } from "../License/utils";

const MenuWrapper = () => {
  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  const { pathname = "" } = useLocation();

  const sidebarOpen = useSelector(
    (state: AppState) => state.system.sidebarOpen,
  );
  const intl = useIntl();

  return (
    <Menu
      isOpen={sidebarOpen}
      displayGroupTitles
      applicationLogo={{
        applicationName: getLogoApplicationVariant(),
        subVariant: getLogoVar(),
      }}
      callPathAction={(path) => {
        navigate(path);
      }}
      signOutAction={() => {
        navigate("/logout");
      }}
      collapseAction={() => {
        dispatch(menuOpen(!sidebarOpen));
      }}
      currentPath={pathname}
      mobileModeAuto={false}
      endComponent={
        <Fragment>
          <MenuItem
            name={intl.formatMessage({ id: 'footer.documentation', defaultMessage: 'Documentation' })}
            icon={<DocumentationIcon />}
            path={
              "https://docs.min.io/community/minio-object-store/index.html?ref=con"
            }
          />
          <MenuItem
            name={intl.formatMessage({ id: 'menu.license', defaultMessage: 'License' })}
            icon={<LicenseIcon />}
            path={IAM_PAGES.LICENSE}
            onClick={() => navigate(IAM_PAGES.LICENSE)}
            badge={!getLicenseConsent()}
          />
        </Fragment>
      }
      middleComponent={
        <>
          <MenuItem
            name={intl.formatMessage({ id: 'bucket.create', defaultMessage: 'Create Bucket' })}
            icon={<AddIcon />}
            onClick={() => dispatch(setAddBucketOpen(true))}
          />
          <BucketsListing />
        </>
      }
    />
  );
};

export default MenuWrapper;
