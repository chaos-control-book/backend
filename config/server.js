module.exports = ({ env }) => ({
  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  url: 'http://chaoscontrol.local/api',
  admin: {
    url: 'http://chaoscontrol.local/dashboard',
    auth: {
      secret: env('ADMIN_JWT_SECRET', '845bffa72d434e7d0ad67ba7073b1624'),
    },
  },
});
