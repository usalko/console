import React, { createContext, useContext, useState, useEffect } from 'react';
import { IntlProvider } from 'react-intl';
import storage from 'local-storage-fallback';

// Импортируем файлы локализации
// import en from './en.json';
// import ru from './ru.json';

// type LocaleMessages = typeof en;
type SupportedLocales = 'en' | 'ru';

const LOCALE_KEY = 'minio_locale';
const DEFAULT_LOCALE = 'en' as const;

// const messages: Record<SupportedLocales, LocaleMessages> = {
//   en,
//   ru,
// };

interface LocaleContextType {
  locale: SupportedLocales;
  setLocale: (locale: SupportedLocales) => void;
}

const LocaleContext = createContext<LocaleContextType>({
  locale: DEFAULT_LOCALE,
  setLocale: () => {},
});

export const useLocale = () => useContext(LocaleContext);

export const LocaleProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [locale, setLocale] = useState<SupportedLocales>(() => {
    const savedLocale = storage.getItem(LOCALE_KEY);
    return (savedLocale === 'ru' ? 'ru' : 'en') as SupportedLocales;
  });

  useEffect(() => {
    storage.setItem(LOCALE_KEY, locale);
    document.documentElement.setAttribute('lang', locale);
  }, [locale]);

  return (
    <LocaleContext.Provider value={{ locale, setLocale }}>
      <IntlProvider 
        locale={locale}
        defaultLocale={DEFAULT_LOCALE}
      >
        {children}
      </IntlProvider>
    </LocaleContext.Provider>
  );
};