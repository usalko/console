# MinIO Console Localization (i18n)

This directory contains internationalization (i18n) resources for the MinIO Console web application.

## Overview

The MinIO Console now supports multiple languages using `react-intl` library. Currently supported languages:
- English (en) - Default
- Russian (ru)

## Files Structure

```
src/locales/
├── en.json              # English translations
├── ru.json              # Russian translations
├── LocaleContext.tsx    # React context provider for locale management
├── LanguageSwitcher.tsx # UI component for language switching
└── README.md           # This file
```

## Usage in Components

### 1. Using the `useIntl` hook

```tsx
import { useIntl } from 'react-intl';

const MyComponent = () => {
  const intl = useIntl();
  
  return (
    <div>
      {intl.formatMessage({ 
        id: 'common.save', 
        defaultMessage: 'Save' 
      })}
    </div>
  );
};
```

### 2. Using `FormattedMessage` component

```tsx
import { FormattedMessage } from 'react-intl';

const MyComponent = () => {
  return (
    <div>
      <FormattedMessage 
        id="common.save" 
        defaultMessage="Save" 
      />
    </div>
  );
};
```

### 3. Messages with variables

```tsx
const intl = useIntl();

intl.formatMessage(
  { 
    id: 'bucket.created',
    defaultMessage: 'Bucket {name} was created successfully'
  },
  { name: bucketName }
);
```

## Adding New Translations

### Step 1: Add translation keys to JSON files

Add your translation key to both `en.json` and `ru.json`:

**en.json:**
```json
{
  "mySection": {
    "myKey": "My English text"
  }
}
```

**ru.json:**
```json
{
  "mySection": {
    "myKey": "Мой русский текст"
  }
}
```

### Step 2: Use in your component

```tsx
import { useIntl } from 'react-intl';

const MyComponent = () => {
  const intl = useIntl();
  
  return <div>{intl.formatMessage({ id: 'mySection.myKey' })}</div>;
};
```

## Translation Key Naming Convention

Follow this hierarchical structure:
- `common.*` - Common UI elements (buttons, labels, etc.)
- `menu.*` - Menu items
- `bucket.*` - Bucket-related translations
- `object.*` - Object-related translations
- `login.*` - Login page translations
- `[feature].*` - Feature-specific translations

Examples:
- `common.save` - Save button
- `menu.objectBrowser` - Object Browser menu item
- `bucket.create` - Create Bucket
- `object.upload` - Upload Object

## Language Switching

The language switcher is automatically included in the page header. Users can switch between languages by clicking the language button (EN/RU).

The selected language is persisted in localStorage and will be remembered across sessions.

## Adding a New Language

### 1. Create a new JSON file

Create `src/locales/[lang-code].json` with all translation keys (use `en.json` as template).

### 2. Update LocaleContext.tsx

```tsx
import newLang from './[lang-code].json';

type SupportedLocales = 'en' | 'ru' | '[lang-code]';

const messages: Record<SupportedLocales, LocaleMessages> = {
  en,
  ru,
  [lang-code]: newLang,
};
```

### 3. Update LanguageSwitcher.tsx (optional)

If you want more than 2 languages, consider using a dropdown instead of a toggle button.

## Best Practices

1. **Always provide a defaultMessage**: This ensures the app works even if a translation is missing.

```tsx
intl.formatMessage({ 
  id: 'my.key', 
  defaultMessage: 'Fallback English text' 
})
```

2. **Use descriptive IDs**: Make IDs self-documenting.
   - ❌ Bad: `msg1`, `text2`
   - ✅ Good: `bucket.create`, `object.delete.confirm`

3. **Group related translations**: Use the hierarchical structure in JSON files.

4. **Avoid hardcoded strings**: Always use translation keys instead of hardcoded text.

5. **Keep translations consistent**: Use the same terminology across the application.

## Testing

To test translations:

1. Start the development server:
```bash
yarn start
```

2. Open the application in your browser
3. Click the language switcher (EN/RU) in the header
4. Verify all text changes to the selected language

## Bucket Descriptions (Russian Labels)

To display Russian descriptions for buckets:

1. Set the `definition` field when creating a bucket (via API or backend)
2. The UI will display: `bucket.name — bucket.definition`
3. The `definition` field can contain any text, including Russian characters

Example API call:
```javascript
{
  "name": "my-bucket",
  "definition": "Моя тестовая корзина"
}
```

This will display as: **my-bucket — Моя тестовая корзина** in the bucket list.

## Troubleshooting

### Translations not showing
- Check that the translation key exists in the JSON file
- Verify the JSON file has valid syntax (no trailing commas, proper quotes)
- Check browser console for errors

### Language not switching
- Clear browser localStorage: `localStorage.clear()`
- Check that LocaleProvider wraps your component tree
- Verify the language code is correct

### Missing translations
- If a key is missing, the `defaultMessage` will be displayed
- Add the missing key to the appropriate JSON file

## Contributing

When adding new features that include user-facing text:

1. Add English translations to `en.json`
2. Add Russian translations to `ru.json`
3. Use `useIntl()` hook or `<FormattedMessage>` component
4. Test both languages before submitting PR

## Resources

- [React Intl Documentation](https://formatjs.io/docs/react-intl/)
- [ICU Message Syntax](https://formatjs.io/docs/core-concepts/icu-syntax/)
- [MinIO Documentation](https://docs.min.io/)
