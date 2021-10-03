module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js",
  ],
  theme: {
    colors: {
      secondary: "#FC5868",
      primary: {
        DEFAULT: "#14134F",
        light: "#2E2CB5",
      },
      accent: "#FFB47C",
      light: "#CFDCFB",
      lighter: "#EDF2FE",
      gray: "#52555B",
      white: "#FFFFFF",
      current: "currentColor",
    },
    fontFamily: {
      sans: ["Red Hat Display", "sans-serif"],
      serif: ["Red Hat Display", "serif"],
    },
    extend: {},
  },
  variants: {},
  plugins: [require("@tailwindcss/forms"), require("tailwind-hamburgers")],
};
