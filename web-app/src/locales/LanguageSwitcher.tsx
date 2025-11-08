import React from 'react';
import { useLocale } from './LocaleContext';

export const LanguageSwitcher: React.FC = () => {
  const { locale, setLocale } = useLocale();

  const toggleLanguage = () => {
    setLocale(locale === 'en' ? 'ru' : 'en');
  };

  return (
    <button 
      onClick={toggleLanguage}
      style={{
        background: 'transparent',
        border: '1px solid currentColor',
        padding: '4px 8px',
        cursor: 'pointer',
        borderRadius: '4px'
      }}
    >
      {locale === 'en' ? 'RU' : 'EN'}
    </button>
  );
};