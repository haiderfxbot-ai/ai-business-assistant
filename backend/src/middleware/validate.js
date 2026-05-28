const validate = (schema) => {
  return (req, res, next) => {
    const errors = [];
    if (schema.body && req.body) {
      for (const [field, rules] of Object.entries(schema.body)) {
        const value = req.body[field];
        if (rules.required && (value === undefined || value === null || value === '')) {
          errors.push(`${field} is required`);
        }
        if (rules.type === 'string' && value && typeof value !== 'string') {
          errors.push(`${field} must be a string`);
        }
        if (rules.minLength && value && value.length < rules.minLength) {
          errors.push(`${field} must be at least ${rules.minLength} characters`);
        }
        if (rules.maxLength && value && value.length > rules.maxLength) {
          errors.push(`${field} must be at most ${rules.maxLength} characters`);
        }
        if (rules.pattern && value && !rules.pattern.test(value)) {
          errors.push(`${field} format is invalid`);
        }
      }
    }
    if (errors.length > 0) {
      return res.status(400).json({ error: 'Validation failed', details: errors });
    }
    next();
  };
};

module.exports = { validate };
