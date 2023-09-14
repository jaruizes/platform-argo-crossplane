import React from 'react';
import { Navigate, Route } from 'react-router-dom';
import { apiDocsPlugin, ApiExplorerPage } from '@backstage/plugin-api-docs';
import {
  CatalogEntityPage,
  CatalogIndexPage,
  catalogPlugin,
} from '@backstage/plugin-catalog';
import {
  CatalogImportPage,
  catalogImportPlugin,
} from '@backstage/plugin-catalog-import';
import { ScaffolderPage, scaffolderPlugin } from '@backstage/plugin-scaffolder';
import { orgPlugin } from '@backstage/plugin-org';
import { SearchPage } from '@backstage/plugin-search';
import { TechRadarPage } from '@backstage/plugin-tech-radar';
import {
  TechDocsIndexPage,
  techdocsPlugin,
  TechDocsReaderPage,
} from '@backstage/plugin-techdocs';
import { TechDocsAddons } from '@backstage/plugin-techdocs-react';
import { ReportIssue } from '@backstage/plugin-techdocs-module-addons-contrib';
import { UserSettingsPage } from '@backstage/plugin-user-settings';
import { apis } from './apis';
import { entityPage } from './components/catalog/EntityPage';
import { searchPage } from './components/search/SearchPage';
import { Root } from './components/Root';

import { AlertDisplay, OAuthRequestDialog } from '@backstage/core-components';
import { createApp } from '@backstage/app-defaults';
import { AppRouter, FlatRoutes } from '@backstage/core-app-api';
import { CatalogGraphPage } from '@backstage/plugin-catalog-graph';
import { RequirePermission } from '@backstage/plugin-permission-react';
import { catalogEntityCreatePermission } from '@backstage/plugin-catalog-common/alpha';

import {BackstageTheme, darkTheme, lightTheme} from '@backstage/theme';
import { ThemeProvider } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
/**
 * The `@backstage/core-components` package exposes this type that
 * contains all Backstage and `material-ui` components that can be
 * overridden along with the classes key those components use.
 */
import { BackstageOverrides } from '@backstage/core-components';
import { HomepageCompositionRoot } from '@backstage/plugin-home';
import { HomePage } from './components/home/HomePage';
import { ChatGPTFrontendPage } from '@enfuse/chatgpt-plugin-frontend';

export const createCustomThemeOverrides = (
    theme: BackstageTheme,
): BackstageOverrides => {
    return {
        BackstageHeader: {
            header: {
                backgroundColor: '#FE4645',
                backgroundImage: ''
            },
            title: {
                color: `white`
            }
        }
    };
};

export const createCustomThemeOverridesHome = (
    theme: BackstageTheme,
): BackstageOverrides => {
    return {
        BackstageHeader: {
            header: {
                backgroundColor: '#FE4645',
                backgroundImage: ''
            },
            title: {
                color: `white`
            }
        }
    };
};

const customTheme: BackstageTheme = {
    ...lightTheme,
    overrides: {
        // These are the overrides that Backstage applies to `material-ui` components
        ...lightTheme.overrides,
        // These are your custom overrides, either to `material-ui` or Backstage components.
        ...createCustomThemeOverrides(lightTheme),
    },
};
const customThemeHome: BackstageTheme = {
    ...darkTheme,
    overrides: {
        // These are the overrides that Backstage applies to `material-ui` components
        ...darkTheme.overrides,
        // These are your custom overrides, either to `material-ui` or Backstage components.
        ...createCustomThemeOverridesHome(darkTheme),
    },
};

const app = createApp({
  apis,
    bindRoutes({ bind }) {
    bind(catalogPlugin.externalRoutes, {
      createComponent: scaffolderPlugin.routes.root,
      viewTechDoc: techdocsPlugin.routes.docRoot,
      createFromTemplate: scaffolderPlugin.routes.selectedTemplate,
    });
    bind(apiDocsPlugin.externalRoutes, {
      registerApi: catalogImportPlugin.routes.importPage,
    });
    bind(scaffolderPlugin.externalRoutes, {
      registerComponent: catalogImportPlugin.routes.importPage,
      viewTechDoc: techdocsPlugin.routes.docRoot,
    });
    bind(orgPlugin.externalRoutes, {
      catalogIndex: catalogPlugin.routes.catalogIndex,
    });
  },
    themes: [{
        id: 'my-theme',
        title: 'My Custom Theme',
        variant: 'dark',
        Provider: ({ children }) => (
            <ThemeProvider theme={customTheme}>
                <CssBaseline>{children}</CssBaseline>
            </ThemeProvider>
        ),
    }]
});

const routes = (
  <FlatRoutes>
    <Route path="/" element={<HomepageCompositionRoot />}>
      <HomePage />
    </Route>
    <Route path="/catalog" element={<CatalogIndexPage />} />
    <Route
      path="/catalog/:namespace/:kind/:name"
      element={<CatalogEntityPage />}
    >
      {entityPage}
    </Route>
    <Route path="/docs" element={<TechDocsIndexPage />} />
    <Route path="/chatgpt" element={<ChatGPTFrontendPage />} />
    <Route
      path="/docs/:namespace/:kind/:name/*"
      element={<TechDocsReaderPage />}
    >
      <TechDocsAddons>
        <ReportIssue />
      </TechDocsAddons>
    </Route>
    <Route path="/create" element={<ScaffolderPage />} />
    <Route path="/api-docs" element={<ApiExplorerPage />} />
    <Route
      path="/tech-radar"
      element={<TechRadarPage width={1500} height={800} />}
    />
    <Route
      path="/catalog-import"
      element={
        <RequirePermission permission={catalogEntityCreatePermission}>
          <CatalogImportPage />
        </RequirePermission>
      }
    />
    <Route path="/search" element={<SearchPage />}>
      {searchPage}
    </Route>
    <Route path="/settings" element={<UserSettingsPage />} />
    <Route path="/catalog-graph" element={<CatalogGraphPage />} />
  </FlatRoutes>
);

export default app.createRoot(
  <>
    <AlertDisplay />
    <OAuthRequestDialog />
    <AppRouter>
      <Root>{routes}</Root>
    </AppRouter>
  </>,
);
