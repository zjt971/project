# PostgreSQL Test Scripts Documentation

## Overview

This document provides comprehensive documentation for the PostgreSQL test scripts created during the database migration process. These scripts are designed to verify that the PostgreSQL database integration is working correctly with the RI Management application.

## Test Scripts

### 1. test-postgresql-crud.js

**Purpose**: Verify basic CRUD (Create, Read, Update, Delete) operations work correctly with PostgreSQL.

**Location**: `code/ri-app/test-postgresql-crud.js`

**Usage**:
```bash
cd code/ri-app
node test-postgresql-crud.js
```

**Test Coverage**:
1. **READ Operations**: Verifies existing data can be retrieved
   - Counts reinsurers and treaties in database
   - Validates data accessibility

2. **CREATE Operation**: Tests data creation
   - Creates a test reinsurer with sample data
   - Validates successful creation with returned data

3. **UPDATE Operation**: Tests data modification
   - Updates the test reinsurer's status and description
   - Validates changes are applied correctly

4. **CREATE with Relations**: Tests complex data creation
   - Creates a treaty with associated reinsurer shares
   - Validates relational data integrity

5. **READ with Relations**: Tests complex data retrieval
   - Retrieves treaty with associated reinsurer data
   - Validates proper relationship loading

6. **DELETE Operations**: Tests data removal
   - Deletes test treaty shares, treaty, and reinsurer
   - Validates proper cascade deletion

7. **Deletion Verification**: Confirms data removal
   - Attempts to retrieve deleted entities
   - Validates they no longer exist

**Expected Output**:
```
🧪 Testing PostgreSQL CRUD Operations...

1️⃣ Testing READ operations...
   ✅ Found [X] reinsurers
   ✅ Found [Y] treaties

2️⃣ Testing CREATE operation...
   ✅ Created reinsurer: Test Reinsurer for PostgreSQL (RIN-TEST-001)

3️⃣ Testing UPDATE operation...
   ✅ Updated reinsurer status to: UNDER_REVIEW

4️⃣ Testing CREATE with relations...
   ✅ Created treaty: Test Treaty for PostgreSQL (TREATY-TEST-001)

5️⃣ Testing READ with relations...
   ✅ Treaty has 1 shares
   ✅ Share belongs to: Test Reinsurer for PostgreSQL

6️⃣ Testing DELETE operations...
   ✅ Deleted test treaty and reinsurer

7️⃣ Verifying deletion...
   ✅ Treaty deleted: true
   ✅ Reinsurer deleted: true

✅ All PostgreSQL CRUD operations completed successfully!
```

**Error Handling**:
- Database connection errors are caught and logged
- Transaction failures are properly reported
- Cleanup is attempted even if errors occur

### 2. test-postgresql-audit-fixed.js

**Purpose**: Verify audit trail functionality works correctly with PostgreSQL database operations.

**Location**: `code/ri-app/test-postgresql-audit-fixed.js`

**Usage**:
```bash
cd code/ri-app
node test-postgresql-audit-fixed.js
```

**Test Coverage**:
1. **CREATE Audit Test**: Verifies audit events are created on data creation
   - Creates a test reinsurer
   - Checks for corresponding audit events

2. **UPDATE Audit Test**: Verifies audit events are created on data modification
   - Updates the test reinsurer
   - Checks for corresponding audit events

3. **Audit Event Verification**: Confirms audit events are properly recorded
   - Retrieves audit events for the test entity
   - Validates event count and metadata

4. **Audit Change Verification**: Confirms field-level changes are tracked
   - Retrieves audit changes for the test entity
   - Validates change details are captured

5. **Audit Change Details**: Verifies specific field changes are recorded
   - Checks CREATE and UPDATE operations
   - Validates old and new values are captured

6. **Complex Entity Audit Test**: Tests audit with more complex entities
   - Creates a test treaty with shares
   - Validates audit trail for complex relationships

7. **Complex Entity Update**: Tests audit trail on complex entity updates
   - Updates the test treaty
   - Validates audit events for complex changes

8. **Complex Entity Verification**: Confirms audit events for complex entities
   - Retrieves audit events for the test treaty
   - Validates proper event recording

9. **Data Cleanup**: Removes test data while preserving audit trail
   - Deletes test treaty and reinsurer
   - Validates cleanup process

10. **Audit Persistence**: Verifies audit trail data persists
    - Counts total audit events and changes
    - Validates audit data integrity

**Expected Output**:
```
🧪 Testing PostgreSQL Audit Trail Functionality...

1️⃣ Testing audit trail on CREATE operation...
   ✅ Created test reinsurer: Audit Test Reinsurer

2️⃣ Testing audit trail on UPDATE operation...
   ✅ Updated reinsurer status to: UNDER_REVIEW

3️⃣ Verifying audit events were created...
   ✅ Found [X] audit events for test reinsurer

4️⃣ Verifying audit changes were recorded...
   ✅ Found [Y] audit changes for test reinsurer

5️⃣ Verifying audit change details...
   ✅ CREATE change recorded: [field] = [old] → [new]
   ✅ UPDATE change recorded: [field] = [old] → [new]

6️⃣ Testing audit trail with complex entity (Treaty)...
   ✅ Created test treaty: Audit Test Treaty

7️⃣ Testing audit trail on treaty UPDATE...
   ✅ Updated treaty status to: PENDING

8️⃣ Verifying treaty audit events...
   ✅ Found [X] audit events for test treaty

9️⃣ Cleaning up test data...
   ✅ Cleaned up test data

🔟 Final verification - checking audit trail persistence...
   ✅ Total audit events in database: [total]
   ✅ Total audit changes in database: [total]

✅ All PostgreSQL audit trail tests completed successfully!
```

**Important Notes**:
- Audit events are only triggered through application service layer
- Direct Prisma operations (like these test scripts) may not trigger audit events
- The test verifies audit table structure and basic functionality
- For complete audit testing, use the application UI

## Integration with Application

### Running Tests During Development

1. **Before Running Tests**:
   - Ensure PostgreSQL database is running and accessible
   - Verify environment variables are set correctly
   - Check database schema is up to date

2. **Running Tests**:
   - Execute scripts from the `code/ri-app` directory
   - Monitor output for success/failure indicators
   - Check for any error messages

3. **After Running Tests**:
   - Verify no test data remains in database
   - Check application functionality through UI
   - Monitor application logs for any issues

### Test Data Management

**Test Data Created**:
- Reinsurer ID: `RIN-TEST-001`, `RIN-AUDIT-TEST`
- Treaty ID: `TREATY-TEST-001`, `TREATY-AUDIT-TEST`
- All test data is automatically cleaned up

**Data Cleanup**:
- Scripts automatically delete test data after completion
- Cleanup occurs even if individual tests fail
- Audit trail data is preserved for verification

## Troubleshooting

### Common Issues

1. **Connection Errors**:
   ```
   Error: Connection refused
   ```
   **Solution**: Check DATABASE_URL environment variable and database server status

2. **Permission Errors**:
   ```
   Error: permission denied for database
   ```
   **Solution**: Verify database user has required permissions

3. **Schema Mismatch**:
   ```
   Error: relation "reinsurer" does not exist
   ```
   **Solution**: Run database migrations: `npm run prisma:migrate:postgres`

4. **Test Data Conflicts**:
   ```
   Error: duplicate key value violates unique constraint
   ```
   **Solution**: Clean up existing test data or use unique test IDs

### Debug Mode

To enable debug output, the scripts include detailed logging. Look for:
- 🔍 [DEBUG] prefixes for detailed operation logs
- ✅ for successful operations
- ❌ for failed operations
- 📊 for data counts and statistics

## Best Practices

### Test Execution

1. **Isolated Environment**: Run tests in a dedicated test environment
2. **Consistent State**: Start with known database state
3. **Clean Cleanup**: Ensure complete data cleanup after tests
4. **Error Logging**: Capture and analyze all errors

### Continuous Integration

1. **Automated Testing**: Integrate scripts into CI/CD pipeline
2. **Test Reporting**: Capture test results for analysis
3. **Failure Alerts**: Set up notifications for test failures
4. **Performance Monitoring**: Track test execution times

## Future Enhancements

### Planned Improvements

1. **Enhanced Test Coverage**: Add more edge case testing
2. **Performance Testing**: Add query performance benchmarks
3. **Load Testing**: Test behavior under high load
4. **Data Validation**: Add data integrity checks

### Extending Test Scripts

To add new test cases:

1. **Follow Existing Patterns**: Use the established structure
2. **Add Proper Cleanup**: Ensure new tests clean up data
3. **Include Error Handling**: Catch and report all errors
4. **Document Changes**: Update this documentation

## Support

For issues with these test scripts:

1. **Check Logs**: Review application and database logs
2. **Verify Environment**: Ensure all prerequisites are met
3. **Consult Documentation**: Refer to PostgreSQL setup guide
4. **Contact Team**: Reach out to development team for assistance

## Related Documentation

- [PostgreSQL Setup Guide](./postgresql-setup-guide.md)
- [PostgreSQL Setup Checklist](./postgresql-setup-checklist.md)
- [Application Architecture Documentation](./architecture/)
- [Database Schema Documentation](../code/ri-app/prisma/schema-postgresql.prisma)